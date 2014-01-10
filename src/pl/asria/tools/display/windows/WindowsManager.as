package pl.asria.tools.display.windows 
{
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class WindowsManager 
	{
		private static var __focusVector:Vector.<Window>;
		private static var liblary:Dictionary = new Dictionary();
		public static var NORMAL_OFFSET:int = 50;
		public function WindowsManager() 
		{
			
		}
		
		/**
		 * Register in system management 
		 * @param	window, focus grup sugegst that every window in this grup have this same parent
		 * @return suggested position of this window
		 */
		static public function register(window:Window):Point 
		{
			var focusVector:Vector.<Window>;
			var mask:ByteArray = new ByteArray();
			mask.length = 100;
			mask.endian = Endian.LITTLE_ENDIAN;
			
			if (liblary[window.focusGrup] == undefined)
			{
				focusVector = new Vector.<Window>();
				liblary[window.focusGrup] = focusVector;
			}
			else
			{
				focusVector = liblary[window.focusGrup] as Vector.<Window>;
			}
			
			if (focusVector.indexOf(window) < 0)
				focusVector.push(window);
			else
				throw new WindowError(WindowError.WINDOW_ALREADY_EXIST.message, WindowError.WINDOW_ALREADY_EXIST.id );
				
			// at this moment function have at least one element
			var position:Point = new Point();
			var boundParent:Rectangle = new Rectangle();
			var boundsWindow:Rectangle = window.getWorkspace();

			if (window.parent is Stage)
			{
				boundParent.width = Stage(window.parent).stageWidth;
				boundParent.height = Stage(window.parent).stageHeight;
			}
			else
			{
				boundParent.width = window.parent.width;
				boundParent.height = window.parent.height;
			}
			
			// crop available space
			boundParent.y += NORMAL_OFFSET;
			boundParent.x += NORMAL_OFFSET;
			boundParent.width -= 2 * NORMAL_OFFSET + boundsWindow.width;
			boundParent.height -= 2 * NORMAL_OFFSET + boundsWindow.height;
			
			//trace("bounds parent", boundParent)
			// determine positions
			if (boundParent.width < 0) 
			{
				position.x = NORMAL_OFFSET - boundsWindow.x;
			}
			else
			{
				position.x = boundParent.x + boundParent.width / 2;
				/*
				//clean byte array
				mask.position = 0;
				while (mask.position < 100)
					mask.writeByte(0);
				// mask currently windows mask
				var currentWindowWs:Rectangle;
				for each (var windowGrup:Window in focusVector)
				{
					currentWindowWs = windowGrup.getWorkspace();
					if (windowGrup.x + currentWindowWs.x < boundParent.x)
					{
						mask.position = 0 ;
						mask.writeByte(1);
						continue;
					}
					
					if (windowGrup.x + currentWindowWs.x > boundParent.right)
					{
						mask.position = 99 ;
						mask.writeByte(1);
						continue;
					}
					mask.position = int((windowGrup.x + currentWindowWs.x - boundParent.x) / boundParent.width);
					mask.writeByte(1);
				}
				// search longest space between windows places
				position.x = boundParent.width * searchPosition(mask) + boundParent.x;
				*/
			}
			
			
			if (boundParent.height < 0)
			{
				position.y = NORMAL_OFFSET - boundsWindow.y;
			}
			else
			{
				position.y = boundParent.y + boundParent.height / 2;
				
				/*mask.position = 0;
				while (mask.position < 100)
					mask.writeByte(0);
				// mask currently windows mask
				for each (windowGrup in focusVector)
				{
					currentWindowWs = windowGrup.getWorkspace();
					if (windowGrup.y + currentWindowWs.y < boundParent.y)
					{
						mask.position = 0 ;
						mask.writeByte(1);
						continue;
					}
					
					if (windowGrup.y + currentWindowWs.y > boundParent.bottom)
					{
						mask.position = 99 ;
						mask.writeByte(1);
						continue;
					}
					mask.position = int((windowGrup.y + currentWindowWs.y - boundParent.y) / boundParent.height);
					mask.writeByte(1);
				}
				// search longest space between windows places
				position.y = boundParent.height * searchPosition(mask) + boundParent.y;*/
				
			}
			return position;
			
		}
		private static function searchPosition(mask:ByteArray):Number
		{
			// search space to put window
			var maxCount:int;
			var localMax:int;
			var localCount:int;
			var lastStartIndex:int;
			var localStartIndex:int;
			var maskLength:int = mask.length;
			
			mask.position = 0;
			localMax = 0;
			localCount = 0;
			lastStartIndex = 0;
			localStartIndex = 0;
			maxCount = 0;
			while (mask.position < maskLength)
			{
				if (!mask.readByte())
				{
					localCount++;
					if (maxCount < localCount)
					{
						lastStartIndex = localStartIndex;
						maxCount = localCount;
					}
				}
				else
				{
					localStartIndex = mask.position;
					localCount = 0;
				}
			}
			//trace(lastStartIndex, maxCount,Number((lastStartIndex + maxCount/2) / maskLength))
			return Number((lastStartIndex + maxCount/2) / maskLength);
		}
		
	}

}