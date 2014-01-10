/**
* CHANGELOG:
*
* 2011-11-03 14:04: Create file
*/
package pl.asria.tools.display 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	/**
	 * Basic interface of Skin object. 
	 * ISkin has very strong coleration with IWorkspace. 
	 * Workspace is usefull to get current values of height and width current content.
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public interface ISkin extends IWorkspace
	{
		///**
		 //* Put some content into skin.
		 //* @param	content
		 //*/
		//function putSkinContent(content:DisplayObject):void;
		//
		///**
		 //* Put skin content and after this, put this skin into parent of content
		 //* @param	content
		 //*/
		//function skinOver(content:DisplayObject):void;
		//
		///**
		 //* return current content of skin, default his is only one shape
		 //*/
		//function get contentSkin():DisplayObjectContainer;
		//
		///**
		 //* Clean skin content
		 //*/
		//function removeSkinContent():void;
		
	}
	
}