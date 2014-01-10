package pl.asria.tools.display.buttons 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import pl.asria.tools.media.sound.ToolSounds;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class PararrellMuteButtonController extends MovieClip
	{
		private var view:MovieClip;
		private var group:String = null;
		private var nameKey:String;
		
		public function get sub():String { return view.currentLabel.split("_")[1] };
		public function get mai():String { return view.currentLabel.split("_")[0] };
		
		public function PararrellMuteButtonController() 
		{
			
		}
		
		public function setView(view:MovieClip, nameKey:String, name:String):PararrellMuteButtonController
		{
			this.nameKey = nameKey;
			this.view = view;
			view.addEventListener(MouseEvent.ROLL_OVER, mouseOverHandler);
			view.addEventListener(MouseEvent.ROLL_OUT, mouseOutandler);
			view.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			view.addEventListener(MouseEvent.CLICK, mouseClickHandler);
			view.buttonMode = true;
			addChild(view);
			view.stop();
			ParerrellMutteButton._dictionary[this] = nameKey;
			if (ParerrellMutteButton._frame) superGotoAndStop(ParerrellMutteButton._frame);
			
			var splited:Array = name.split("$");
			for each (var command:String in splited)
			{
				var _cmd:Array = command.split("_");
				if (_cmd[0] == "muteGroup")
				{
					group = _cmd[1];
				}
			}
			return this;
		}
		
		private function mouseDownHandler(e:MouseEvent):void 
		{
			gotoAndStop(mai+"_click");
		}
		
		private function mouseOutandler(e:MouseEvent):void 
		{
			gotoAndStop(mai+"_idle");
		}
		
		private function mouseClickHandler(e:MouseEvent):void 
		{
			if (mai == "on")
			{
				gotoAndStop("off_idle");
			}
			else
			{
				gotoAndStop("on_idle");
			}
		}
		
		private function mouseOverHandler(e:MouseEvent):void 
		{
			gotoAndStop(mai+"_on");
		}
		
		internal function superGotoAndStop(frame:Object):void
		{
			//changeLabels();
			view.gotoAndStop(frame);
		}
		
		override public function gotoAndStop(frame:Object, scene:String = null):void 
		{
			trace( "PararrellMuteButtonController.gotoAndStop > frame : " + frame + ", scene : " + scene );
			view.gotoAndStop(frame, scene);
			ParerrellMutteButton._frame = frame;
			for (var key:Object in ParerrellMutteButton._dictionary)
				if(ParerrellMutteButton._dictionary[key] == nameKey)
					key["superGotoAndStop"](ParerrellMutteButton._frame);
					
			if (mai == "on")
			{
				ToolSounds.setVolume(0, group);
			}
			else 
			{
				ToolSounds.setVolume(1, group);
			}
		}
		
		public function clean():void
		{
			delete ParerrellMutteButton._dictionary[this];
			view.removeEventListener(MouseEvent.ROLL_OVER, mouseOverHandler);
			view.removeEventListener(MouseEvent.ROLL_OUT, mouseOutandler);
			view.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			view.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
			view = null;
		}
		
	}

}