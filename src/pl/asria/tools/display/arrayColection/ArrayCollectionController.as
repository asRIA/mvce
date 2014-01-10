/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-05-21 10:34</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.arrayColection 
{
	import com.greensock.easing.Back;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import pl.asria.tools.display.ui.ScrollBarController;
	import pl.asria.tools.event.display.ui.ScrollbarEvent;
	import pl.asria.tools.event.ExtendEventDispatcher;
	
	public class ArrayCollectionController extends ExtendEventDispatcher
	{
		protected var _scrollBar:ScrollBarController;
		protected var _arrayCollectionContent:ArrayCollectionContentView;
		protected var _hieghtAC:int;
		protected var _workspace:Rectangle;
	
		/**
		 * ArrayCollectionController - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function ArrayCollectionController() 
		{
			
		}
		
		
		public function init(hieghtAC:int, workspace:Rectangle):void
		{
			_workspace = workspace;
			_hieghtAC = hieghtAC;
			
		}
		
		public function initScrollBar(scrollBar:ScrollBarController):void
		{
			_scrollBar = scrollBar;
			_scrollBar.addEventListener(ScrollbarEvent.CHANGE_INDEX, changeIndexHandler);
			
		}
		
		protected function changeIndexHandler(e:ScrollbarEvent):void 
		{
			// getTargetPosition
			if (_arrayCollectionContent.length > 0)
			{
				if (e.data != 0)
				{
					var _y:Number = -_arrayCollectionContent.getPositionOf(e.data);
				}
				else
				{
					_y = 0;
				}
				
			
				TweenLite.killTweensOf(_arrayCollectionContent);
				// start animation
				TweenLite.to(_arrayCollectionContent, 0.25, {y:_y+_workspace.y, ease:Back.easeOut});
			}
			
		}
		
		public function initContent(arrayCollectionContent:ArrayCollectionContentView):void
		{
			_arrayCollectionContent = arrayCollectionContent;
			_arrayCollectionContent.addEventListener(Event.CHANGE, changeACContentHandler);
		}
		
		protected function changeACContentHandler(e:Event):void 
		{
			// update scrollbar buttons
			_scrollBar.setRange(0, _arrayCollectionContent.length - _hieghtAC);
		}
		
		public function clean():void
		{
			_scrollBar.removeEventListener(ScrollbarEvent.CHANGE_INDEX, changeIndexHandler);
			_scrollBar = null;
			_arrayCollectionContent = null;
		}
	}

}