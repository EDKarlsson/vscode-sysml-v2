import { writeFileSync } from 'fs'
import { mergeObject } from 'json-merger'

import template from '../syntaxes/template.tmLanguage.json'

const merged = JSON.stringify(mergeObject(template), null, 2)

const tmLanguageFile = 'syntaxes/sysml.tmLanguage.json'

writeFileSync(tmLanguageFile, merged, {
    flag: 'w',
})
