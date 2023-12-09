#!/usr/bin/env node
const fs = require("fs");
const path = require("path");

module.exports = function (context) {
  const rootdir = context.opts.projectRoot;
  const indexHtmlPath = path.join(rootdir, "www", "index.html");
  let indexHtmlData = fs.readFileSync(indexHtmlPath, "utf-8").toString();
  indexHtmlData = webCommentConfig(indexHtmlData);
  indexHtmlData = cordovaAddConfig(indexHtmlData);
  fs.writeFileSync(indexHtmlPath, indexHtmlData);
};

function webCommentConfig(fileString) {
  fileString = fileString.replace(
    "<!-- web-version-config-off -->",
    "<!-- web-version-config-off"
  );
  fileString = fileString.replace(
    "<!-- end-web-version-config-off -->",
    "end-web-version-config-off -->"
  );
  return fileString;
}

function cordovaAddConfig(fileString) {
  const configHeader = `
    <meta http-equiv="Content-Security-Policy"
          content="default-src *; style-src * 'unsafe-inline'; script-src * 'unsafe-inline' 'unsafe-eval'; img-src * data: 'unsafe-inline'; connect-src * 'unsafe-inline'; frame-src *;">
    <meta http-equiv="Content-Security-Policy"
          content="default-src * gap://ready file:; style-src 'self' 'unsafe-inline' *; script-src 'self' 'unsafe-inline' 'unsafe-eval' *">
    <meta name="format-detection" content="telephone=no">
    <meta name="msapplication-tap-highlight" content="no">
    <meta name="viewport" content="initial-scale=1, width=device-width, viewport-fit=cover">
    <style>
       * {
          -webkit-user-select: none;
          -khtml-user-select: none;
          -moz-user-select: none;
          -ms-user-select: none;
          user-select: none;
        }

        input {
          -webkit-user-select: auto !important;
          -khtml-user-select: auto !important;
          -moz-user-select: auto !important;
          -ms-user-select: auto !important;
          user-select: auto !important;
        }
    </style>
   `;
  const configScript = `
   <script>
    (function () {
        'use strict';

        window.addEventListener = function () {
        EventTarget.prototype.addEventListener.apply(this, arguments);
        };

        window.removeEventListener = function () {
        EventTarget.prototype.removeEventListener.apply(this, arguments);
        };

        document.addEventListener = function () {
        EventTarget.prototype.addEventListener.apply(this, arguments);
        };

        document.removeEventListener = function () {
        EventTarget.prototype.removeEventListener.apply(this, arguments);
        };
    })();
    </script>
    <script type="text/javascript" src="cordova.js"></script>
   `;
  fileString = fileString.replace(
    "<!-- cordova-config header here -->",
    configHeader
  );
  fileString = fileString.replace(
    "<!-- cordova-config script here -->",
    configScript
  );

  return fileString;
}
