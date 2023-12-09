const fs = require("fs");
const path = require("path");
const { exec } = require("child_process");
const dir = process.argv.slice(2, 3)[0] === "prod" ? "apk" : "debugApk";

const init = async function () {
  const configXmlPath = path.join(__dirname, "..", "config.xml");
  let data = fs.readFileSync(configXmlPath, "utf-8").toString();
  const version = getVersion(data);
  const rmdir = `rm -rf ~/freelance/toc/backend/tmp/${dir}`;
  const mkdir = `mkdir -p ~/freelance/toc/backend/tmp/${dir}`;
  const cpApk = `cp ~/freelance/toc/cordova/platforms/android/app/build/outputs/apk/debug/app-debug.apk ~/freelance/toc/backend/tmp/${dir}/mypin.${version}.apk`;
  await exec(
    `${rmdir} && ${mkdir} && ${cpApk} && cd ../backend && npm run push-apk`
  );
};

init();

function getVersion(fileString) {
  const REGEX = /<widget.*version="([^"]+)"/;
  const matches = fileString.match(REGEX);
  return matches[1];
}
