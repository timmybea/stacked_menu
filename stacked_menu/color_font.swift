//
//  ColorManager.swift
//  stacked_menu
//
//  Created by Tim Beals on 2017-03-02.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class ColorManager: NSObject {

    class func customGrayBlue() -> UIColor {
        return UIColor(displayP3Red: 89/255, green: 112/255, blue: 129/255, alpha: 1)
    }
    
    class func customDarkGray() -> UIColor {
        return UIColor(displayP3Red: 54/255, green: 73/255, blue: 78/255, alpha: 1)
    }
}

class FontManager: NSObject {
    
    class func headingFont() -> UIFont {
        return UIFont(name: "BanglaSangamMN-Bold", size: 25)!
    }
}



class PlaceHolderText: NSObject {
    
    class func textViewText() -> String {
        let string: String = "1. Fill large pot about 2/3 full with water, salt it liberally and bring to a boil over high heat \n\n2. Meanwhile, heat a wide, deep heavy skillet over medium heat. Pour in the olive oil until it is shimmering and almost smoking. Add the garlic, anchovies, onions and capers and cook, stirring with a wooden spoon, until the onions are softened but not browned, about 4 minutes. Pour in the wine and bring to a simmer, then lower the heat and simmer until the wine has almost completely evaporated, about 5 minutes."
     
        return string
    }
    
}
