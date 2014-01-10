package pl.asria.tools.display.popups 
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import pl.asria.framework.display.popups.BasePopup;
	import pl.asria.tools.BlockTool;
	import pl.asria.tools.display.block.IBlockContainer;
	import pl.asria.tools.display.block.IBlockIteam;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - trzeci.eu
	 */
	public class BlockPopup extends BasePopup implements IBlockContainer
	{
		private var vBlockIteam:Vector.<IBlockIteam> = new Vector.<IBlockIteam>();
		private var blocked:Boolean;
		
		public function BlockPopup() 
		{
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		protected function onRemoveFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			//BlockTool.unblockAll();
		}
		
		/* INTERFACE pl.asria.tools.display.block.IBlockContainer */
		override protected function onAddedToStage(event:Event):void 
		{
			super.onAddedToStage(event);
			checkPathToStageAndRegisterInIBlockConteiner();
			//BlockTool.blockAll();
			$unblock();
		}
		public function get $blockContents():Vector.<IBlockIteam> 
		{
			return vBlockIteam;
		}
		
		public function $registerBlockIteam(iteam:IBlockIteam):void 
		{
			vBlockIteam.push(iteam);
		}
		
		public function $block():void 
		{
			blocked = true;
			for each (var iteam:IBlockIteam in vBlockIteam)
			{
				iteam.$block();
			}
		}
		
		/**
		 * Odblokowanie zawartych w tym kontenerze obiektów
		 */
		public function $unblock():void 
		{
			blocked = false;
			for each (var iteam:IBlockIteam in vBlockIteam)
			{
				iteam.$block();
			}
		}
		
		public function $forceUnblock():void 
		{
			blocked = false;
			for each (var iteam:IBlockIteam in vBlockIteam)
			{
				iteam.$forceUnblock();
			}
		}
		
		public function clickHandlerBlock():void 
		{
			
		}
		
		/* INTERFACE pl.asria.tools.display.block.IBlockContainer */
		
		public function checkPathToStageAndRegisterInIBlockConteiner():void 
		{
			var _parent:DisplayObject = parent;
			while (_parent != null && !(_parent is Stage))
			{
				if (_parent is IBlockContainer)
				{
					IBlockContainer(_parent).$registerBlockIteam(this);
					return;
				}
				else
					_parent = _parent.parent;
			}
		}
		
		public function get $isBlocked():Boolean 
		{
			for each (var iteam:IBlockIteam in vBlockIteam)
				if (iteam.$isBlocked) 
					return true;
			return false;
		}
		
	}
	
}