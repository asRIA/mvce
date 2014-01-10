package pl.asria.tools.display.block 
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Piotr Paczkowski
	 */
	public interface IBlockContainer extends IBlockIteam
	{
		function get $blockContents():Vector.<IBlockIteam>;
		function $registerBlockIteam(iteam:IBlockIteam):void;
	}
	
}