package pl.asria.tools 
{
	import flash.utils.Dictionary;
	import pl.asria.tools.display.block.IBlockContainer;
	import pl.asria.tools.display.block.IBlockIteam;
	import pl.asria.tools.display.buttons.BlockButton;
	
	/**
	 * ...
	 * @author Piotr Paczkowski
	 */
	public class BlockTool 
	{
		private static var _globalEnable:Boolean = true;
		private static var vIteams:Vector.<IBlockIteam> = new Vector.<IBlockIteam>();

		static public function get globalEnable():Boolean 
		{
			return _globalEnable;
		}
		
		static public function set globalEnable(value:Boolean):void 
		{
			_globalEnable = value;
		}
		
		static public function forceUnblockAll():void
		{
			for each (var iteam:IBlockIteam in vIteams)
				iteam.$forceUnblock();
		}
		static public function unblockAll():void
		{
			for each (var iteam:IBlockIteam in vIteams)
				iteam.$unblock();
		}
		static public function blockAll():void
		{
			for each (var iteam:IBlockIteam in vIteams)
				iteam.$block();
		}
		
		static public function registerButton(blockIteam:IBlockIteam):void
		{
			if(blockIteam is IBlockContainer) throw new Error("Can not register IBlockContainers");
			if (vIteams.indexOf(blockIteam) < 0)
				vIteams.push(blockIteam);
		}
		
		static public function unregisterButton(blockIteam:IBlockIteam):void 
		{
			if(blockIteam is IBlockContainer) throw new Error("Can not unregister non-IBlockContainers instances");
			var index:int = vIteams.indexOf(blockIteam);
			if (index >= 0)
				vIteams.splice(index, 1);
		}
		
		
	}
	
}