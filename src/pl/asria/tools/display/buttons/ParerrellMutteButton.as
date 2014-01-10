/**
* CHANGELOG:
*
* 2011-11-24 16:33: Create file
*/
package pl.asria.tools.display.buttons 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import pl.asria.framework.display.buttons.MuteButton;
	import pl.asria.tools.media.sound.ToolSounds;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class ParerrellMutteButton extends MuteButton
	{
		protected var _groupName:String;
		protected var _view:MovieClip;
		internal static var _frame:Object;
		internal static const _dictionary:Dictionary = new Dictionary(true);
		internal static const _dGroups:Dictionary = new Dictionary(true);
		private var group:String = null;
		
		public function ParerrellMutteButton(view:MovieClip = null, groups:Array = null, groupName:String = null) 
		{
			super(view, groups, groupName);
			_view = view || this;
			_view.mouseChildren = false;
			_groupName = groupName;
			
			if (_frame) superGotoAndStop(_frame);
			
			var splited:Array = name.split("$");
			for each (var command:String in splited)
			{
				var _cmd:Array = command.split("_");
				if (_cmd[0] == "muteGroup")
				{
					group = _cmd[1];
				}
			}
			if (groupName != null) group = groupName;
			_dictionary[this] = group;
			
			_view.addEventListener(Event.ADDED_TO_STAGE, onAdded, false, int.MIN_VALUE , true);
			syncWithGroupLabel();
		}
		
		
		override public function get name():String 
		{
			return super.name;
		}
		
		override public function set name(value:String):void 
		{
			super.name = value;
			
			var splited:Array = name.split("$");
			for each (var command:String in splited)
			{
				var _cmd:Array = command.split("_");
				if (_cmd[0] == "muteGroup")
				{
					group = _cmd[1];
					break;
				}
			}
			if (_groupName != null) group = _groupName;
			
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			syncWithGroupLabel();
			//superGotoAndStop(_frame);
		}
		override public function get currentFrameLabel():String 
		{
			return _view.currentFrameLabel;
		}
		
		
		override public function gotoAndStop(frame:Object, scene:String = null):void 
		{
			super.gotoAndStop(frame, scene);
			_frame = frame;
			_dGroups[group] = frame;
			for (var key:Object in _dictionary)
				if(_dictionary[key] == group)
					(key as ParerrellMutteButton).superGotoAndStop(_frame);
					
			if (currentFrameLabel.indexOf("on") == 0)
			{
				ToolSounds.setVolume(0, group);
			}
			else 
			{
				ToolSounds.setVolume(ToolSounds.getVolumeFromSO(group,1), group);
			}
		}
		
		internal function superGotoAndStop(frame:Object):void
		{
			changeLabels();
			super.gotoAndStop(frame);
		}
		
		protected function syncWithGroupLabel():void 
		{
			if (_dGroups[group] != undefined) superGotoAndStop(_dGroups[group]);
		}
	}

}