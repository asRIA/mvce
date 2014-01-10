/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-10-03 22:21</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.ui.drag 
{
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.filters.GlowFilter;
	
	
	/** 
	* Dispatched when ... 
	**/
	[Event(name="rollOutSupported", type="pl.asria.tools.display.ui.drag.DragManagerEvent")]
	/** 
	* Dispatched when ... 
	**/
	[Event(name = "rollOutUnsupported", type = "pl.asria.tools.display.ui.drag.DragManagerEvent")]
	/** 
	* Dispatched when some unsupported content is over those content
	**/
	[Event(name="rollOnUnsupported", type="pl.asria.tools.display.ui.drag.DragManagerEvent")]
	/** 
	* Dispatched when supported content is over those content
	**/
	[Event(name="rollOnSupported", type="pl.asria.tools.display.ui.drag.DragManagerEvent")]
	/** 
	* Dispatched when global manager note that some supported stag object is just dragged
	**/
	[Event(name="startDragSupportedItem", type="pl.asria.tools.display.ui.drag.DragManagerEvent")]
	/** 
	* Dispatched when global manager note that some not-supported stag object is just dragged
	**/
	[Event(name="startDragUnsupportedItem", type="pl.asria.tools.display.ui.drag.DragManagerEvent")]
	/** 
	* Dispatched when some supported content is droped on this content
	**/
	[Event(name="dropContent", type="pl.asria.tools.display.ui.drag.DragManagerEvent")]
	/**
	 * Dispatched when some UN-supported content is droped on this content
	 */
	[Event(name="dropContentUnsupported", type="pl.asria.tools.display.ui.drag.DragManagerEvent")]
	public class DragTarget extends EventDispatcher
	{
		public var supportedTypes:Array;
		public var displayTarget:Sprite;
		/**  **/
		public static const SUPPORTED:String = "supported";
		/**  **/
		public static const UNSUPPORTED:String = "unsupported";
		/**  **/
		public static const NONE:String = "none";
		public var data:*;
	
		/**
		 * DragTarget - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function DragTarget(displayTarget:Sprite, supportedTypes:Array = null) 
		{
			this.supportedTypes = supportedTypes || [];
			this.displayTarget = displayTarget;
		}
		
		public function isSupported(type:String):Boolean
		{
			return supportedTypes.indexOf(type) >= 0;
		}
		
		public function decorateObject(type:String):void 
		{
			switch(type)
			{
				case SUPPORTED:
				{
					TweenMax.to(displayTarget, 0.3, {glowFilter:{color:0x33cc66, alpha:1, blurX:4, blurY:4, strength:5}});
					break;
				}
				case UNSUPPORTED:
				{
					TweenMax.to(displayTarget, 0.3, {glowFilter:{color:0xff3300, alpha:1, blurX:4, blurY:4, strength:5}});
					break
				}
				case NONE:
				default:
				{
					TweenMax.to(displayTarget, 0.3, {glowFilter:{ alpha:0, blurX:4, blurY:4, strength:5}});
				}
			}
		}
		
		public function unregister():void 
		{
			DragManager.instance.unregisterTarget(this);
		}
		public function register():void 
		{
			DragManager.instance.registerTarget(this);
		}
		
		
		
	}

}