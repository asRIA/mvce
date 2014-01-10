/*
Copyright (c) 2008 Christopher Martin-Sperry (audiofx.org@gmail.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package pl.asria.tools.media.sound
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import pl.asria.tools.performance.Chunk;
	import pl.asria.tools.performance.IChunk;
	
	/**
	 * Dispatched when the MP3 data is loaded
	* @eventType org.audiofx.mp3.MP3SoundEvent.COMPLETE 
	* 
	*/
	[Event(name="complete", type="pl.asria.tools.media.sound.MP3SoundEvent")]
	/**
	 * Class for loading MP3 files from a FileReference
	 * @author spender
	 * @see flash.net.FileReference
	 */
	[Event(name="error", type="pl.asria.tools.media.sound.MP3SoundEvent")]
	public class MP3Transcoder extends EventDispatcher implements IChunk
	{
		
		[Embed(source="soundClassSwfBytes1.bin", mimeType="application/octet-stream")]
		internal static const soundClassSwfBytes1Class:Class;
		public static const soundClassSwfBytes1data:ByteArray = new soundClassSwfBytes1Class() as ByteArray;
		
		[Embed(source="soundClassSwfBytes2.bin", mimeType="application/octet-stream")]
		internal static const soundClassSwfBytes2Class:Class;
		public static const soundClassSwfBytes2data:ByteArray = new soundClassSwfBytes2Class() as ByteArray;
		
		[Embed(source="soundClassSwfBytes3.bin", mimeType="application/octet-stream")]
		internal static const soundClassSwfBytes3Class:Class;
		public static const soundClassSwfBytes3data:ByteArray = new soundClassSwfBytes3Class() as ByteArray;
		
		
		private var swfBytes:ByteArray;
		private var currentPos:uint;
		private var swfBytesLoader:Loader;
		private var swfSizePosition:uint;
		private var audioSizePosition:uint;
		private var sampleSizePosition:uint;
		private var frameCount:uint;
		private var byteCount:uint;
		private var mp3Parsel:MP3Parser;
		
		/**
		 * Constructs an new MP3FileReferenceLoader instance 
		 * 
		 */
		public function MP3Transcoder()
		{
			mp3Parsel=new MP3Parser();
			
		}
		/**
		 * Once a FileReference instance has been obtained, and the user has browsed to a file, call getSound to start loading the MP3 data.
		 * When the data is ready, an <code>MP3SoundEvent.COMPLETE</code> event is emitted.
		 * @param fr A reference to a local file.
		 * @see MP3SoundEvent
		 */
		public function getSound(data:ByteArray):void
		{
			mp3Parsel.loadByteArray(data);
			swfBytes=new ByteArray();
			swfBytes.endian = Endian.LITTLE_ENDIAN;
			swfBytes.writeBytes(soundClassSwfBytes1data);
			
			swfSizePosition=swfBytes.position;
			swfBytes.writeInt(0); //swf size will go here
			swfBytes.writeBytes(soundClassSwfBytes2data);
			
			audioSizePosition=swfBytes.position;
			swfBytes.writeInt(0); //audiodatasize+7 to go here
			swfBytes.writeByte(1);
			swfBytes.writeByte(0);
			mp3Parsel.writeSwfFormatByte(swfBytes);
			
			sampleSizePosition=swfBytes.position;
			swfBytes.writeInt(0); //number of samples goes here
			
			swfBytes.writeByte(0); //seeksamples
			swfBytes.writeByte(0);
						
			frameCount=0;
			byteCount=0; //this includes the seeksamples written earlier
			
			
			// preparate chunk calculations
			var chunk:Chunk = new Chunk(this,true);
			chunk.addEventListener(Event.COMPLETE, completeChunkCalculationHandler);
			chunk.start();
		}
					
		public function resetChunk():void 
		{
			
		}
		
		public function updateChunk():Boolean 
		{
			var seg:ByteArraySegment=mp3Parsel.getNextFrame();
			if (seg == null) return false;
			
			swfBytes.writeBytes(seg.byteArray,seg.start,seg.length);
			byteCount+=seg.length;
			frameCount++;
			return true;
		}
		
		private function completeChunkCalculationHandler(e:Event):void 
		{
			if(byteCount==0)
			{
				trace("Invalid data");
				dispatchEvent(new MP3SoundEvent(MP3SoundEvent.ERROR, null));
				swfBytes.clear();
				return;
			}
			byteCount += 2;
			
			currentPos = swfBytes.position;
			
			swfBytes.position=audioSizePosition;
			swfBytes.writeInt(byteCount + 7);
			
			swfBytes.position=sampleSizePosition;
			swfBytes.writeInt(frameCount * 1152);
			
			swfBytes.position = currentPos;
			swfBytes.writeBytes(soundClassSwfBytes3data);
			
			swfBytes.position=swfSizePosition;
			swfBytes.writeInt(swfBytes.length);
			swfBytes.position = 0;
			
			
			swfBytesLoader=new Loader();
			swfBytesLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfCreated);
			swfBytesLoader.loadBytes(swfBytes);
		}

		private function swfCreated(ev:Event):void
		{
			var loaderInfo:LoaderInfo=ev.currentTarget as LoaderInfo;
			var soundClass:Class=loaderInfo.applicationDomain.getDefinition("SoundClass") as Class;
			//var sound:Sound = new soundClass();
			swfBytes.clear();
			mp3Parsel.clear();
			swfBytesLoader.unload();
			dispatchEvent(new MP3SoundEvent(MP3SoundEvent.COMPLETE,soundClass));
			
		}

	}
}