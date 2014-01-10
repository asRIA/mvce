package pl.asria.tools.utils 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.engine.TextLine;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class DisplayObjectUtils 
	{
		static private var dActualMenuContext:Dictionary = new Dictionary();
		
		public function DisplayObjectUtils() 
		{
			
		}
		/**
		 * Dodaje menu kontextowe do prawokliku
		 * @param	contener 
		 * @param	name nazwa jaka ma być pokazana 
		 * @param	separator czy ma być poprzedzona separatorem
		 * @param	reaction String-> navigateToUrl, jeśli funkcja to wywołuje ją bezargumentowo
		 */
		public static function addMenuItem(contener:Sprite, name:String, separator:Boolean, reaction:Object):void
		{
			if (!contener)
			{
				trace("*DisplayObjectUtils # addMenuItem: null reference");
			}
			else
			{
				if (null == dActualMenuContext[contener]) dActualMenuContext[contener] = new ContextMenu();
				var menuItem:ContextMenuItem = new ContextMenuItem(name);
				menuItem.separatorBefore = separator;
				
				var menuResp:Object = new Object();
				if (reaction != null)
				{
					if (reaction is String)
					{
						menuResp.responde = function (e:ContextMenuEvent):void
						{
							var lr:URLRequest = new URLRequest(reaction as String);
							navigateToURL(lr, "_blank");
						}
					}
					else if (reaction is Function)
					{
						menuResp.responde = function (e:ContextMenuEvent):void
						{
							reaction();
						}
					}
					menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuResp.responde);
				}
				else
				{
					trace("*StageSettings #addMenuItem: brak zdefiniowanego responde");
				}
				dActualMenuContext[contener].hideBuiltInItems();
				dActualMenuContext[contener].customItems.push(menuItem);
				Sprite(contener).contextMenu = dActualMenuContext[contener];
			}
		}
		
		public static function getArrayDisplayObjectFromDO(dispCont:DisplayObjectContainer, deepth:Number= 0):Array
		{
			var ret:Array = [];
			for (var i:int = 0; i < dispCont.numChildren; i++) 
			{
				var ob:Object = dispCont.getChildAt(i);
				if ((ob is DisplayObjectContainer) &&(deepth != 0)) ret = ret.concat(getArrayDisplayObjectFromDO(ob as DisplayObjectContainer,deepth-1))
				ret.push(ob);
			}
			if (dispCont is TextLine)
			{
				for (i = 0; i < (dispCont as TextLine).atomCount; i++) 
				{
					if ((dispCont as TextLine).getAtomGraphic(i) != null) ret.push((dispCont as TextLine).getAtomGraphic(i));
					
				}
			}
			return ret;
		}
		
		/**
		 * Calculate in radians
		 * @param	y
		 * @param	x
		 * @return
		 */
		public static function angleCalc(y:Number, x:Number):Number
		{
			var ang:Number = Math.atan2(y, x);
			/*ang += ang < 0 ? 2 * Math.PI : 0;
			ang = ang * 180 / Math.PI;
			ang = ang < 0 ? 360 + ang : ang;*/
			return(ang);
		}
	}

}