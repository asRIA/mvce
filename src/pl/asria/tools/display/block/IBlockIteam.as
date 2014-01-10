package pl.asria.tools.display.block 
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Piotr Paczkowski
	 */
	public interface IBlockIteam 
	{
		function $block():void;
		function $unblock():void;
		function $forceUnblock():void;
		function clickHandlerBlock():void
		function get $isBlocked():Boolean;
		function get parent () : DisplayObjectContainer;
		function checkPathToStageAndRegisterInIBlockConteiner():void
	}
	
}