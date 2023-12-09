#!/usr/bin/env node
const fs = require("fs");
const path = require("path");

module.exports = function (context) {
  const rootdir = context.opts.projectRoot;
  const configXmlPath = path.join(rootdir, "config.xml");
  let data = fs.readFileSync(configXmlPath, "utf-8").toString();
  const version = incVersion(getVersion(data));
  data = saveVersion(data, version);
  fs.writeFileSync(configXmlPath, data);
};

function getVersion(fileString) {
  const REGEX = /<widget.*version="([^"]+)"/;
  const matches = fileString.match(REGEX);
  return matches[1];
}

function incVersion(version) {
  let splitVersion = version.split(".");
  splitVersion[2]++;
  return splitVersion.join(".");
}

function saveVersion(fileString, version) {
  return fileString.replace(/<widget.*version="([^"]+)"/, (match) => {
    return match.replace(/version="([^"]+)"/, `version="${version}"`);
  });
}
