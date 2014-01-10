package pl.asria.tools.display.arrayColection
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import pl.asria.tools.display.IWorkspace;
	import pl.asria.tools.display.ui.ScrollbarBase;
	import pl.asria.tools.event.display.ui.ScrollbarEvent;
	
	/**
	 * ...
	 * @author Piotr Paczkowski
	 */
	public class ArrayCollection extends Sprite implements IWorkspace
	{
		private var arrayColectionContener:Sprite;
		public var scrollBar:ScrollbarBase;
		public var workspace:Sprite;
		
		private var vArrayColectionIteams:Vector.<IWorkspace> = new Vector.<IWorkspace>();
		private var currentFocused:int;
		private var _lockInsertX:Boolean;
		private var _lockInsertY:Boolean;
		private var _scroolOverChilds:Boolean = false;
		public function ArrayCollection()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			arrayColectionContener = new Sprite();
			addChild(arrayColectionContener);
			if (scrollBar) scrollBar.addEventListener(ScrollbarEvent.CHANGE_INDEX, changeIndexHandler);
		}
		
		private function changeIndexHandler(e:ScrollbarEvent):void 
		{
			setFocused(e.data);
		}
		
		public function get collection():Vector.<IWorkspace>
		{
			return vArrayColectionIteams;
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			arrayColectionContener.x = getWorkspace().x;
			arrayColectionContener.y = getWorkspace().y;
			arrayColectionContener.mask = workspace;
		}
		
		/*TODO	add insert in index X */
		public function pushIteam(arrayColectionIteam:IWorkspace):void
		{
			if (!arrayColectionIteam is DisplayObject)
				throw new Error("Array Collection Iteam must be displayObject!");
			DisplayObject(arrayColectionIteam).y = getColectionsHeight() - arrayColectionIteam.getWorkspace().y;
			//DisplayObject(arrayColectionIteam).x = -arrayColectionIteam.getWorkspace().x;
			
			arrayColectionContener.addChild(DisplayObject(arrayColectionIteam));
			vArrayColectionIteams.push(arrayColectionIteam);
			
			// calc bounds
			var offsetX:int = arrayColectionContener.height -getWorkspace().height;
			
			if (scrollBar)
			{
				if (offsetX <= 0)
				{
					scrollBar.setRange(0,0);
				}
				else
				{
					scrollBar.setRange(0,arrayColectionContener.height/getWorkspace().height);
				}
			}
			
			//setFocused(currentFocused);
		}
		
		public function cleanIteams():void
		{
			while (vArrayColectionIteams.length > 0)
				arrayColectionContener.removeChild(vArrayColectionIteams.pop());
			if (scrollBar) scrollBar.setRange(0, 0);
			arrayColectionContener.y = getWorkspace().y;
			arrayColectionContener.x = getWorkspace().x;
		}
		
		private function getColectionsHeight():Number
		{
			var _y:Number = 0;
			for each (var iteam:IWorkspace in vArrayColectionIteams)
			{
				_y += iteam.getWorkspace().height;
			}
			return _y;
		}
		
		/* TODO	Add index X focused*/
		private function setFocused(indexY:int, indexX:int = 0):void
		{
			trace( "ArrayCollection.setFocused > indexY : " + indexY + ", indexX : " + indexX );
			TweenLite.killTweensOf(arrayColectionContener);
			var rec:Rectangle = getWorkspace();
			var transformation:Object = {y:rec.y, x:rec.x, onComplete:managementChilds};
			// calculate transform y
			
			if (arrayColectionContener.height >= rec.height)
			{
				if (!_scroolOverChilds)
				{
					indexY = indexY < 0 ? 0 : indexY > scrollBar.rangeMax ? scrollBar.rangeMax : indexY;
					transformation.y = -getWorkspace().height * indexY;
				}
				else
				{
					indexY = indexY < 0 ? 0 : indexY > (vArrayColectionIteams.length - 1) ? (vArrayColectionIteams.length - 1) : indexY;
					transformation.y = -DisplayObject(vArrayColectionIteams[indexY]).y;
					if (arrayColectionContener.height + transformation.y < rec.height)
						transformation.y = -arrayColectionContener.height + rec.height;
					else
						currentFocused = indexY;
					transformation.y += rec.y;
				}
				
			}
			
			
			// calculate transform x
			/*if (arrayColectionContener.width >= rec.width && 0==1)
			{
				indexX = indexX < 0 ? 0 : indexX > (vArrayColectionIteams.length - 1) ? (vArrayColectionIteams.length - 1) : indexX;
				transformation.x = -DisplayObject(vArrayColectionIteams[indexY]).x;
				if (arrayColectionContener.width + transformation.x < workspace.width)
					transformation.x = -arrayColectionContener.width + workspace.width;
				else
					currentFocused = indexX;
				transformation.x += workspace.x;
			}*/
			
			//if (currentFocused == 0)
			//arrayColectionUp.visible = Boolean(currentFocused);
			//arrayColectionDown.visible = Boolean(currentFocused < (vArrayColectionIteams.length - 1));
			//arrayColectionDown.visible = false;
			TweenLite.to(arrayColectionContener, 0.2, transformation);
		}
		
		/**
		 * TODO	Add managment after ang before transformations
		 * Remove invisible childs
		 */
		private function managementChilds():void 
		{
			
		}
		
		/* INTERFACE pl.asria.utils.workspace.IWorkspace */
		
		public function getWorkspace():Rectangle
		{
			return workspace.getBounds(this);
		}
		
		public function pushIteams(vIteams:*):void 
		{
			for each (var node:IWorkspace in vIteams)
				pushIteam(node);
		}
		
		override public function get height():Number
		{
			return getWorkspace().height;
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
		}
		
		override public function get width():Number
		{
			return getWorkspace().width;
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
		}
		
		public function get lockInsertX():Boolean 
		{
			return _lockInsertX;
		}
		
		public function set lockInsertX(value:Boolean):void 
		{
			_lockInsertX = value;
		}
		
		public function get lockInsertY():Boolean 
		{
			return _lockInsertY;
		}
		
		public function set lockInsertY(value:Boolean):void 
		{
			_lockInsertY = value;
		}
		[Inspectable (name = "scroolOverChilds", variable = "scroolOverChilds", type = "Boolean", defaultValue = 'false', category = 'Other')]
		public function get scroolOverChilds():Boolean 
		{
			return _scroolOverChilds;
		}
		
		public function set scroolOverChilds(value:Boolean):void 
		{
			_scroolOverChilds = value;
		}
	}

}