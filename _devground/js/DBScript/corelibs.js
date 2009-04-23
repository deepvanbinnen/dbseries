/**
 *   DBScript headerfiles definition
 *   
 *   Adds nampespaces, sourcelocations and names used with the DBScript.import statement
 *   
 *   @requires DBScript as an instance of DBScriptHandler 
 *   @see DBscript#setLibMap
 *   @see DBscript#import
 */

/**
 * Core headerfiles 
 */
DBScript.setLibMap("DBScript.core.Dollar"    , "dollar"    , "corelibs/dollar.js");
DBScript.setLibMap("DBScript.core.Events"    , "events"    , "corelibs/events.js");
DBScript.setLibMap("DBScript.core.Classes"   , "classes"   , "corelibs/classes.js");
DBScript.setLibMap("DBScript.core.DOMHelper" , "domhelper" , "corelibs/domhelper.js");
DBScript.setLibMap("DBScript.core.XHR"       , "xhr"       , "corelibs/xhr.js");


/**
 * Library headerfiles 
 */
DBScript.setLibMap("DBScript.lib.Keyboard"    , "lib/keyboard"    , "lib/keyboard.js");
DBScript.setLibMap("DBScript.lib.PopupWindow" , "lib/popupwin"    , "lib/popupwin.js");
DBScript.setLibMap("DBScript.lib.TableClass"  , "lib/tables"      , "lib/tables.js");
DBScript.setLibMap("DBScript.lib.Formelement" , "lib/formelement" , "lib/formelement.js");