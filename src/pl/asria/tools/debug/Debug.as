package pl.asria.tools.debug
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import pl.asria.tools.utils.StringUtils;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - trzeci.eu
	 */
	public class Debug extends TextField
	{
		private static var db:TextField;
		private static var yy:Number;
		private static var xx:Number;
		private static var st:Stage;
		private static var LEVEL:Number = 2;
		
		private static var count:Number = 0;
		private static var inverse:Boolean = true;
		private static var stack:Array= [];
		private static var permanentDisable:Boolean = false;
		
		/**
		 * 2:Errors, 1:+warnings, 0:+traces
		 */
		public static function set level(lvl:Number):void
		{
			LEVEL = lvl;
		}
		public function Debug():void
		{
			addEventListener(Event.ADDED_TO_STAGE, evInit);
		}
		public static function bindVersion(versionObject:Object):void
		{
			debug(versionObject);
		}

		private function evInit(e:Event):void
		{
			Debug.init(this);
		}
		/**
		 * 	Inicjalizacja wyświetlania debug log
		 * @param	obj	TextField or Stage
		 */
		public static function init(obj:Object):void
		{
			if (!Capabilities.isDebugger) return;
			if (obj is TextField) 
			{
				db = obj as TextField;
			}
			else if (obj is Stage)
			{
				db = new TextField();
				db.addEventListener(Event.ADDED_TO_STAGE, flushStacked);
				obj.addChild(db);
			}
			else {
				return;
			}
			if (null == obj)
			{
				error("Debug->init(), null obj variable");
				return;
			}
			else
			{
				debug("debug inited");				
			}
			db.visible = false;
			yy = db.y;
			xx = db.x;
			st = db.stage;
			db.height = st.stageHeight;
			db.width = st.stageWidth;
			db.background = true;
			db.backgroundColor = 0x000000;
			db.borderColor = 0x000000;
			db.defaultTextFormat = new TextFormat("_sans", 10);
			db.defaultTextFormat.kerning = false;
			db.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyResponde);
			db.textColor = 0x00FF00;

			
			while (stack.length > 0)
			{
				debug(stack.shift(), 0,true);
			}
		}
		private static function flushStacked(e:Event):void
		{
			//st.removeEventListener(Event.ADDED_TO_STAGE, flushStacked);
			while (stack.length > 0)
			{
				debug(stack.shift(), 0,true);
			}
		}
		private static function keyResponde(e:KeyboardEvent):void
		{
			if (permanentDisable) return;
			//trace([e.type, e.keyLocation, e.ctrlKey, e.charCode, e.altKey]);
			if ((e.altKey == true) && (e.ctrlKey == true))
			{
				if (true == db.visible )
				{
					db.x = xx;
					db.y = xx;
					db.visible  = false;
				}
				else
				{
					db.x = 0;
					db.y = 0;
					db.visible  = true;
					try
					{
						st.removeChild(db);
					}
					catch (e:Error) { }
					st.addChild(db);
				}
			}
			if ((e.shiftKey == true) && (e.ctrlKey == true)&&(db.visible  == true))
			{
				clear();
			}
		}
		public static function clear():void
		{
			db.text = "";
			count = 0;
		}
		/**
		 * 
		 * @param	e Trace
		 * @param	level 0:hight, 1:medium, 2:normal, 3-Inf no important
		 */
		public static function debug(_trace:Object, level:Number = 2 , stackFlush:Boolean = false):void
		{
			
			if (level <= LEVEL)
			{
				if (!stackFlush) trace(""+_trace);
				if ((null != db)&&(null != db.stage))
				{
					//db.htmlText += encapsule(_trace)+db.text;
					db.text = encapsule(_trace)+db.text;
				}
				else
				{
					stack.push(_trace);
				}
			}
			count++;
		}
		private static function encapsule(trac:Object):String
		{
			//return " <font face=\"_sans\">[" + count + "]:" + trac+"</font><br>\n";
			return "[" + count + "]:" + trac+"\n";
		}
		public static function error(e:Object):void
		{
			//debug("<font face=\"_sans\"><b>#ERROR: " + e+"</b></font>",0);
			debug("#ERROR: " + e,0);
		}
		public static function warning(e:Object):void
		{
			//debug("<font face=\"_sans\"><i>#WARINIG: " + e+"</i></font>",1);
			debug("#WARINIG: " + e,1);
		}
		protected static var currDepth:Number = 0;
		public static function deepDebug(object:Object, depth:Number = 10):void
		{
			debug(deepTraceObject(object, depth));
		}
		public static function deepTraceObject(object:Object, depth:Number = 1):String
		{
			var ret:String = '';
			if (object is Array)
			{	
				for (var i:int = 0; i < object.length; i++) 
				{
					ret += StringUtils.cosntSekwenceRepeater("┃\t", currDepth)  + "┣[" + i + "] " +((object[i] is Array)?"[array]":object[i]) + '\n'; 
					currDepth++;
					ret += deepTraceObject(object[i], depth - 1);
					currDepth--;
				}
				
				return ret;
			}
			for (var child:String in object)
			{
				ret += StringUtils.cosntSekwenceRepeater("┃\t", currDepth) + "┣" + child  + ": " + ((object[child] is Array)?"[array]":object[child])+"\n";
				currDepth++;
				if (depth != 0) ret +=  deepTraceObject(object[child], depth - 1);
				currDepth--;
			}
			return ret;
		}
	}
}