package pl.asria.tools.performance.example 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import pl.asria.tools.performance.Chunk;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class ChunkExample extends Sprite
	{
		private var __stats:BitmapData;
		private var __sprite:Sprite;
		private var __i:int;
		private var __toogle:Boolean;
		private var __chunk:Chunk;
		private var __chunkExample:ChunkCalcExample;
		private var __time2:int;
		private var __time:int;
		
		
		private var ui:usser_interface;
		public function ChunkExample() 
		{
			addChild(new FramerateStats());
			__stats = new BitmapData(800, 100, true);
			var bitampStats:Bitmap = new Bitmap(__stats);
			bitampStats.y = 500;
			addChild(bitampStats);
			addEventListener(Event.ADDED_TO_STAGE, init);
			ui = new usser_interface();
			ui.y = 100;
			ui.lAsync.text = "";
			ui.lSync.text = "";
			ui.bAsync.addEventListener(MouseEvent.CLICK, clickAsync);
			ui.bSync.addEventListener(MouseEvent.CLICK, clickSync);
			ui.cFx.addEventListener("change", changeListeners);
			addChild(ui);
		}
		
		private function changeListeners(e:Event):void 
		{
			if (__sprite.filters.length)
				__sprite.filters = [];
			else
				__sprite.filters = [new BlurFilter(50, 50, 3)];
		}
		
		private function clickSync(e:MouseEvent):void 
		{
			__chunkExample.resetChunk();
			__time = getTimer();
			while (__chunkExample.updateChunk()) { }
			ui.lSync.text = "time: " + (getTimer() - __time);
		}
		private function completeChunkHandler(e:Event):void 
		{
			ui.lAsync.text = "time: " +   (getTimer() - __time);
		}
		
		private function clickAsync(e:MouseEvent):void 
		{
			__time = getTimer();
			__chunk.start();
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			chunkTest();
		}
		private function chunkTest():void 
		{
			__sprite = new Sprite();
			
			__sprite.graphics.beginFill(0x000000);
			__sprite.graphics.drawRect( -60, -30, 120, 60);
			__sprite.x = 300;
			__sprite.y = 300;
			__chunkExample = new ChunkCalcExample();
			__chunk = new Chunk(10, true, __chunkExample, stage.frameRate);
			__chunk.addEventListener(Event.COMPLETE, completeChunkHandler);
			addChild(__sprite);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			addEventListener(Event.EXIT_FRAME, exitFrameHandler);
		}
		private function exitFrameHandler(e:Event):void 
		{
			__stats.lock();
			__stats.setPixel(__i, 100-getTimer()+ __time2, 0xFF0000);
			__stats.unlock();
			__time2 = getTimer();
		}
		private function enterFrameHandler(e:Event):void 
		{
			__i++;
			if (__i == 801)
			{
				__i = 1;
				__stats.fillRect(new Rectangle(0,0,800,100), 0xFFFFFFFF);
			}
			__stats.lock();
			__stats.setPixel(__i, 100-getTimer()+ __time2, 0x0000FF);
			__stats.unlock();
			
			__time2 = getTimer();
			__sprite.rotation +=5;
		}
		
	}

}