"use strict";

const {Resolver} = require("node:dns/promises");
const {readFileSync} = require("node:fs");
const {join} = require("node:path");

const NO_RECORD_CODES = new Set(["ENODATA", "ENOTFOUND"]);
const DISPOSABLE_DOMAINS = new Set(
  readFileSync(join(__dirname, "data/disposable_email_blocklist.conf"), "utf8")
    .split(/\r?\n/)
    .map((domain) => domain.trim().toLowerCase())
    .filter(Boolean),
);
const PERMANENT_DOMAINS = new Set([
  "proton.me", "protonmail.com", "protonmail.ch", "pm.me",
  "icloud.com", "privaterelay.appleid.com",
]);

function isDisposableDomain(domain) {
  if (PERMANENT_DOMAINS.has(domain)) {
    return false;
  }
  const labels = domain.split(".");
  for (let index = 0; index < labels.length - 1; index++) {
    if (DISPOSABLE_DOMAINS.has(labels.slice(index).join("."))) {
      return true;
    }
  }
  return false;
}

function normalizeEmailDomain(value) {
  const domain = typeof value === "string" ? value.trim().toLowerCase() : "";
  const labels = domain.split(".");
  if (domain.length > 253 || labels.length < 2 ||
      !labels.every((label) =>
        /^[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?$/.test(label)) ||
      !/^(?:[a-z]{2,63}|xn--[a-z0-9-]+)$/.test(labels.at(-1))) {
    const error = new Error("Invalid email domain.");
    error.code = "invalid-argument";
    throw error;
  }
  return domain;
}

async function checkEmailDomain(value, resolver = new Resolver({
  timeout: 3000,
  tries: 1,
})) {
  const domain = normalizeEmailDomain(value);
  if (isDisposableDomain(domain)) {
    return {valid: false, reason: "disposable"};
  }
  let exchanges;
  try {
    exchanges = await resolver.resolveMx(domain);
  } catch (error) {
    if (error.code === "ENOTFOUND") {
      return {valid: false};
    }
    if (error.code !== "ENODATA") {
      throw error;
    }
    exchanges = [];
  }

  if (exchanges.length > 0) {
    // Node represents a null MX (RFC 7505) as an empty exchange or ".".
    return {
      valid: exchanges.some(({exchange}) => exchange && exchange !== "."),
    };
  }

  // SMTP permits an A/AAAA fallback when the domain has no MX record.
  const addresses = await Promise.allSettled([
    resolver.resolve4(domain),
    resolver.resolve6(domain),
  ]);
  if (addresses.some((result) =>
    result.status === "fulfilled" && result.value.length > 0)) {
    return {valid: true};
  }
  const temporaryFailure = addresses.find((result) =>
    result.status === "rejected" && !NO_RECORD_CODES.has(result.reason.code));
  if (temporaryFailure) {
    throw temporaryFailure.reason;
  }
  return {valid: false};
}

module.exports = {checkEmailDomain};
