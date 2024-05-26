// translate_json_files.mjs
import fs from 'fs';
import path from 'path';
import { translateText } from './translate.mjs';
import { fileURLToPath } from 'url';

// If __dirname is not defined, we need to define it for ESM modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const rawTextDir = path.join(__dirname, './ignore-raw_text_translations');

async function translateJsonFiles(dir) {
    const files = fs.readdirSync(dir);

    for (const file of files) {
        const filePath = path.join(dir, file);
        const jsonData = JSON.parse(fs.readFileSync(filePath, 'utf8'));
        console.log(`Translating file: ${file}`);

        for (const key in jsonData) {
            if (jsonData.hasOwnProperty(key)) {
                const originalText = jsonData[key];
                const translatedText = await translateText(originalText);
                jsonData[key] = translatedText;
            }
        }

        fs.writeFileSync(filePath, JSON.stringify(jsonData, null, 2), 'utf8');
        console.log(`Translated and saved: ${file}`);
    }
}

async function main() {
    await translateJsonFiles(rawTextDir);
    await translateJsonFiles(rawTextRegexDir);
}

main().catch(console.error);
