//
//  xmlProcessingFunctions.swift
//  moonshot
//
//  Created by Adam on 16/08/2026.
//

import Foundation
import libxml2
// xslt isn't part of iOS SDK, so use xml2

// getting p elements for align block div to pass to collatex_json funciton ::
/*py
 iDiv = div.get('{http://www.w3.org/XML/1998/namespace}id')
 for divEz in B1.xpath(f"//text//div[@corresp='{iDiv}']"):
     iDivEz = divEz.get('{http://www.w3.org/XML/1998/namespace}id')

 outputDivElement = etree.Element("div")
 outputDivElement.attrib["{http://www.w3.org/XML/1998/namespace}id"] = f'divColl{str(propreId)}'
 outputDivElement.attrib["corresp"]  = f"{iDiv}_{iDivEz}"
 
 target_ps = A1.xpath(f"//text//div[@xml:id='{iDiv}']/p")

 for i, par in (enumerate(target_ps, start=1)):
     i = par.get("n")
     A = par
     json_input = {}
     json_input['witnesses'] = []
     json_input['witnesses'].append(xml_to_collatex_json('A',A))

     b_blocks = B1.xpath(f"//text//div[@xml:id='{iDivEz}']/p[@n='{i}']")
     for p in b_blocks:
         if len(b_blocks) >0:
             B = p
             json_input['witnesses'].append(xml_to_collatex_json('B',B))
         else:
             print(f"No b blocks for iDiv == {iDiv} == {iDivEz}")

 */
// get para for text A :: First lookup (file 1): get the p block via iDiv



// then run with

