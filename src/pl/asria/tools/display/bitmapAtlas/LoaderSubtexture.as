/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-12-04 18:56</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.bitmapAtlas 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import pl.asria.tools.managers.IJugglable;
	import pl.asria.tools.managers.SEnterFrameJuggler;
	
	
	public class LoaderSubtexture extends Loader implements IJugglable
	{
		protected var _atlas:XML;
		protected var _id:String;
		protected var bmd:Vector.<BitmapData>;
		protected var _currentFrame:int;
		protected var _renderer:Bitmap;
		protected var _url:String;
		
		/**
		 * LoaderSubtexture - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function LoaderSubtexture() 
		{
			contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHadnler, false, int.MAX_VALUE);
		}
		
		public function get enableJuggler():Boolean 
		{
			return bmd!= null;
		}
		
		public function update(offestTime:int):void 
		{
			try
			{
				_renderer.bitmapData = bmd[(++_currentFrame) % bmd.length];
			}
			catch(e:Error){}
		}
		
		override public function unload():void 
		{
			SEnterFrameJuggler.unregister(this);
			if (bmd)
			{
				for (var i:int = 0, i_max:int = bmd.length; i < i_max; i++) 
				{
					bmd[i].dispose();
				}
			}
			super.unload();
		}
		
		protected function onCompleteHadnler(e:Event):void 
		{
			if (_atlas && _id)
			{
				var atlas:TextureBitmapAtlas = new TextureBitmapAtlas((content as Bitmap).bitmapData, _atlas);
				try
				{
					bmd = atlas.getTextures(_id);
				}
				catch (e:Error) { };
				if (bmd && bmd.length)
				{
					if (bmd.length > 1)
					{
						SEnterFrameJuggler.register(this);
					}
					_renderer = (content as Bitmap);
					_renderer.bitmapData =  bmd[0];
					_currentFrame = 0;
				}
			}
		}
		
		public override function load(request:URLRequest, context:LoaderContext = null):void 
		{
			context ||= new LoaderContext();
			context.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
			super.load(request, context);
			_atlas = null;
			_id = null;
		}
		
		public function loadAtlasSubtexture(requestAtlas:URLRequest, requestImage:URLRequest, id:String, context:LoaderContext = null):void
		{
			var urlloadr:URLLoader = new URLLoader(requestAtlas);
			urlloadr.addEventListener(Event.COMPLETE, onCompleteLoadAtlasHandler);
			urlloadr.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			function onCompleteLoadAtlasHandler(e:Event):void
			{
				var xml:XML = new XML(urlloadr.data);
				loadSubtexture(requestImage, xml, id, context);
				urlloadr.removeEventListener(Event.COMPLETE, onCompleteLoadAtlasHandler);
				urlloadr.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			}
			function onErrorHandler(e:IOErrorEvent):void 
			{
				urlloadr.removeEventListener(Event.COMPLETE, onCompleteLoadAtlasHandler);
				urlloadr.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			}
		}
		
		public function loadSubtexture(request:URLRequest, atlas:XML, id:String, context:LoaderContext = null, force:Boolean = true):void
		{
			if(force || _url!=request.url || id != _id) super.load(request, context);
			_url = request.url;
			_id = id;
			_atlas = atlas;
		}
		
		/* INTERFACE pl.asria.tools.managers.IJugglable */
		
		
		
	}
	
}