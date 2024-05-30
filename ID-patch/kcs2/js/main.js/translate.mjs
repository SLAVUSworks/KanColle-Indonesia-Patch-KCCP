import translate from 'translate';

translate.engine = 'google'; // Specify the translation engine
translate.key = undefined; // No API key needed for free usage

async function translateText(text, sourceLang = 'en', targetLang = 'id') {
    try {
        console.log(`Translating text: "${text}"`);
        const translatedText = await translate(text, { from: sourceLang, to: targetLang });
        console.log(`Translation result: "${translatedText}"`);
        return translatedText;
    } catch (error) {
        console.error('Error translating text:', error.message);
        return text; // Return the original text in case of error
    }
}

export { translateText };
