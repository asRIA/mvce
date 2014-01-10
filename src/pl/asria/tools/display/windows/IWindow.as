package pl.asria.tools.display.windows 
{
	import flash.display.Sprite;
	import pl.asria.tools.display.IWorkspace;
	import pl.asria.tools.managers.focus.IFocusManagerObject;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public interface IWindow extends IFocusManagerObject
	{
		function set minimalize(value:Boolean):void;
		function get minimalize():Boolean;
		function close():void;
		function setGrupName():void;
		function registerInWindowsManagerAfterAddToStage():void;
		//remooves listeners, unregister form WindowsManager
		function clean():void;
		
		function set content(content:Sprite):void;
		function get content():Sprite;
		
		function set title(value:String):void;
		function get title():String;
		
		function set scrollX(value:Boolean):void;
		function set scrollY(value:Boolean):void;
		function get scrollY():Boolean;
		function get scrollX():Boolean;
		
		function set scalableX(value:Boolean):void;
		function set scalableY(value:Boolean):void;
		function get scalableX():Boolean;
		function get scalableY():Boolean;
	}
	
}