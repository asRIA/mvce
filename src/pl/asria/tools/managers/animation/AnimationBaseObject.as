/**
* CHANGELOG:
*
* 2011-11-30 16:40: Create file
*/
package pl.asria.tools.managers.animation 
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	[Event(name="completeLabel", type="flash.events.Event")]
	public class AnimationBaseObject extends MovieClip
	{
		private var _labels:Array;
		
		public function AnimationBaseObject() 
		{
			_labels = [];
			for each (var label:FrameLabel in currentLabels)
				_labels.push(label.name);
		}
		
/*		public function haveLayer(label:String):Boolean
		{
			return _labels.indexOf(label) >= 0;
		}*/
		
		/*public function getLabelType(baseType:String):Vector.<String>
		{
			var result:Vector.<String> = new Vector.<String>();
			for each (var _label:String in _labels)
			{
				if (_label.indexOf(baseType) == 0)
					result.push(_label);
			}
			return result;
		}*/
		
	}

}