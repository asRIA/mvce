/**
 * 0.1 2011-08-30 14:23 Utworzenie
 */

package pl.asria.tools.managers.focus 
{
	import flash.utils.Dictionary;
	
	/**
	 * Klasa zapewnia zarządzanie obiektamy które umożliwiaja ich fokus jakikolwiek
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class FocusManager 
	{
		public static const STATE_FOCUS:int = 1;
		public static const STATE_UNFOCUS:int = 0;
		public static const STATE_NOSET:int = -1;
		
		private static var _instance:FocusManager;
		private static var liblary:Dictionary = new Dictionary();
		
		public static function get instance():FocusManager 
		{
			if(null == _instance) _instance = new FocusManager(new Lock());
			return _instance;
		}
		
		public function FocusManager(key:Lock) 
		{
			if(key == null) throw new Error("FocusManager is a Singleton Design Pattern, please use FocusManager.instance to get definition");
		}
		
		public function unregister(object:IFocusManagerObject):void 
		{
			if (object.focusGrup == null)
				throw new Error("Grup is not set yet"); 
				
			var vector:Vector.<IFocusManagerObject> = FocusManager.liblary[object.focusGrup] as Vector.<IFocusManagerObject>;
			var index:int = vector.indexOf(object);
			if (index >= 0)
			{
				vector.splice(index,0);
			}
		}
		
		public function register(object:IFocusManagerObject):FocusManager 
		{
			if (object.focusGrup == null)
				throw new Error("Group is not set yet");
				
			if (FocusManager.liblary[object.focusGrup] == undefined)
				FocusManager.liblary[object.focusGrup] = new Vector.<IFocusManagerObject>();
			var vector:Vector.<IFocusManagerObject> = FocusManager.liblary[object.focusGrup] as Vector.<IFocusManagerObject>;
			if (vector.indexOf(object) < 0)
			{
				vector.push(object);
			}
			return _instance;
		}
		
		public function focusOn(object:IFocusManagerObject):void
		{
			if (object.focusGrup == null)
				throw new Error("Grup is not set yet");
				
			var vector:Vector.<IFocusManagerObject> = FocusManager.liblary[object.focusGrup] as Vector.<IFocusManagerObject>;
			
			// unfocus phase
			for each (var objectFocus:IFocusManagerObject in vector)
				if (objectFocus.focus != FocusManager.STATE_UNFOCUS && object != objectFocus)
					objectFocus.focus = FocusManager.STATE_UNFOCUS;
			
			// focus phase
			for each (objectFocus in vector)
				if (object == objectFocus && objectFocus.focus != FocusManager.STATE_FOCUS)
					objectFocus.focus = FocusManager.STATE_FOCUS;
		}
		
		/**
		 * Get proper objects in state in group
		 * @param	group
		 * @param	state
		 * @return
		 */
		public function getObjectIn(group:String, state:int = FocusManager.STATE_FOCUS):Vector.<IFocusManagerObject>
		{
			var result:Vector.<IFocusManagerObject> = new Vector.<IFocusManagerObject>();
			if (undefined == liblary[group]) return result;
			for each (var object:IFocusManagerObject in  liblary[group]) 
			{
				if (object.focus == state)
					result.push(object);
			}
			return result;
		}
		
		public function unfocus(...grups):void
		{
			var vector:Vector.<IFocusManagerObject>;
			for each (var grup:String in grups)
			{
				if (undefined == FocusManager.liblary[grup]) continue;
				vector = FocusManager.liblary[grup] as Vector.<IFocusManagerObject>;
				for each (var objectFocus:IFocusManagerObject in vector)
				{
					if (objectFocus.focus)
						objectFocus.focus = FocusManager.STATE_UNFOCUS;
				}
			}
		}
		
	}
	
}

/**
* Singleton internal lock
*/
internal class Lock { }