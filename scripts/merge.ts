import { mergeFile } from "json-merger";
var result = mergeFile("a.json");
console.log(result);

import jsonData from '../syntaxes/sysml.extend.tmLanguage.json';
console.log(jsonData);

// var obj_a_1 = 
// {
//   "$merge": {
//     "source": {
//       "$import": "b.json"
//     },
//     "with": {
//       "prop1": {
//         "$replace": {
//           "prop1a": "this will replace b.json's property prop1"
//         }
//       },
//       "prop2": {
//         "prop2a": "this will merge with b.json's property prop2"
//       }
//     }
//   }
// };

// var obj_b_1 = 
// {
//   "prop1": {
//     "prop1b": "will be replaced"
//   },
//   "prop2": {
//     "prop2b": "will be merged"
//   }
// };

// var result = jsonMerger.mergeObjects([obj_a_1, obj_b_1]);