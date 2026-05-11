"use strict";

const admin = require("firebase-admin/app");
const {textToSpeech} = require("./text_to_speech");

admin.initializeApp();

exports.textToSpeech = textToSpeech;
