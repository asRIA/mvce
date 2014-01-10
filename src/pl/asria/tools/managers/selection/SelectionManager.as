/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-10-04 19:57</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.managers.selection 
{
	import adobe.utils.CustomActions;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import pl.asria.tools.utils.getClass;
	import pl.asria.tools.utils.isBasedOn;
	
	/** 
	* Dispatched when selections are chaged 
	**/
	[Event(name="changeSelection", type="pl.asria.tools.managers.selection.SelectionManagerEvent")]
	public class SelectionManager extends EventDispatcher
	{
		protected var _dSelected:Dictionary = new Dictionary(true);
		/**  **/
		public static const MULTISELECT_NONE:String = "multiselectNone";
		/**  **/
		public static const MULTISELECT_TYPE_RANGE_NONE:String = "multiselectTypeRange";
		/**  **/
		public static const MULTISELECT_GLOBAL:String = "multiselectGlobalRange";
		
		
		/** reference to singleton Class **/
		private static var _instance:SelectionManager;
		/** private lock to avoid usage constuctor. **/
		private static var _lock:Boolean = true;
		
		public static function get instance():SelectionManager 
		{
			if(null == _instance) 
			{
				_lock = false;
				_instance = new SelectionManager();
				_lock = true;
			}
			return _instance;
		}
		
		/**
		 * Singleton Class of SelectionManager - 
		 * @usage - access via: .instance only
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function SelectionManager() 
		{
			if(_lock) throw new Error("SelectionManager is a Singleton Design Pattern, please use SelectionManager.instance to get definition");
		}
		
		/**
		 * Inject batch of selections elements
		 * @param	selections
		 */
		public function injectSelections(selections:Dictionary):void
		{
			cleanSelections();
			_dSelected = selections || new Dictionary(true);
			dispatchEvent(new SelectionManagerEvent(SelectionManagerEvent.CHANGE_SELECTION, selections, null))
		}
		
		public function processElement(element:*, multiselection:String = "multiselectNone"):void
		{
			var type:Class = getClass(element);
			
			var dRemoved:Dictionary;
			var dAdded:Dictionary;
			switch(multiselection)
			{
				case MULTISELECT_TYPE_RANGE_NONE: // non protect in local type: in local type. After select unselected, other selected will be unselect. After select already selected, ontly this will be selected. Other will be unselected.
					var elements:Array = _dSelected[type];
					if (elements && elements.length)
					{
						var index:int = elements.indexOf(element);
						if (index >= 0) 
						{
							elements.splice(index, 1);
							if (!elements.length)
							{
								delete _dSelected[type];
							}
						}
						else
						{
							dAdded = new Dictionary(true);
							dAdded[type] = [element];
						}
						dRemoved = new Dictionary(true);
						dRemoved[type] = elements;
						
					}
					else
					{
						dAdded = new Dictionary(true);
						dAdded[type] = [element];
					}
					_dSelected[type] = [element];
					break;
					
				case MULTISELECT_GLOBAL:
					elements = _dSelected[type];
					if (elements && elements.length)
					{
						index = elements.indexOf(element);
						if (index < 0) 
						{
							elements.push(element);
							dAdded = new Dictionary(true);
							dAdded[type] = [element];
						}
						else
						{
							elements.splice(index, 1);
							if (!elements.length)
							{
								delete _dSelected[type];
							}
							dRemoved = new Dictionary(true);
							dRemoved[type] = [element];
						}
					}
					else
					{
						_dSelected[type] = [element];
						dAdded = new Dictionary(true);
						dAdded[type] = [element];
					}
					break;
					
				default:
				case MULTISELECT_NONE:
					elements = _dSelected[type];
					if (elements)
					{
						index = elements.indexOf(element);
						if (index >= 0)
						{
							elements.splice(index, 1);
							if (elements.length == 0) delete _dSelected[type];
						}
						else
						{
							dAdded = new Dictionary(true);
							dAdded[type] = [element];
						}
					}
					else
					{
						dAdded = new Dictionary(true);
						dAdded[type] = [element];
						
					}
					dRemoved = _dSelected;
					_dSelected = new Dictionary(true);
					_dSelected[type] = [element];
					break;
			}
			
			var exist:Boolean;
			for (var key:Object in dAdded) 
			{
				exist = true;
				break;
			}
			if(!exist) dAdded = null;
			exist = false;
			
			for (key in dRemoved) 
			{
				exist = true;
				break;
			}
			if(!exist) dRemoved = null;

			if (dAdded || dRemoved)	
				dispatchEvent(new SelectionManagerEvent(SelectionManagerEvent.CHANGE_SELECTION, dAdded, dRemoved))
		}
		
		public function cleanSelections(type:Class = null):void
		{
			if (!type)
			{
				var tmp:Dictionary = _dSelected;
				_dSelected = new Dictionary(true);
				dispatchEvent(new SelectionManagerEvent(SelectionManagerEvent.CHANGE_SELECTION,null,tmp))
			}
			else
			{
				var elements:Array = _dSelected[type];
				if (elements && elements.length)
				{
					tmp = new Dictionary(true);
					tmp[type] = elements;
					delete _dSelected[type];
					dispatchEvent(new SelectionManagerEvent(SelectionManagerEvent.CHANGE_SELECTION,null,tmp))
				}
			}
			
		}
		
		public function retriveSuperType(superType:Class):Array
		{
			var result:Array = [];
			for (var type:Object in _dSelected) 
			{
				var typeClass:Class = type as Class;
				if (superType == typeClass || isBasedOn(typeClass, superType))
				{
					result = result.concat(retriveType(typeClass));
				}
			}
			return result;
		}
		public function retriveType(type:Class):Array
		{
			return _dSelected[type] || [];
		}
		
		public function touch():void 
		{
			dispatchEvent(new SelectionManagerEvent(SelectionManagerEvent.CHANGE_SELECTION, null, null));
		}
	}
}