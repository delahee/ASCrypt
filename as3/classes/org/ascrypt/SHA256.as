﻿package org.ascrypt
{
	import org.ascrypt.utilities.*;
	
	/**
	* Computes a SHA-256 checksum for the specified data.
	* <br/><br/>SHA-256 is a cryptographic hash function that computes a message digest of 256 bits.
	* @author Mika Palmu
	*/
	public class SHA256
	{
		/**
		* Computes a SHA-256 checksum for the bytes.
		* @param bytes An array of bytes in any encoding.
		* @return An array of SHA-256 computed bytes.
		*/
		public static function compute(bytes:Array):Array
		{
			var b:Array = UTIL.pack(bytes, false);
			return UTIL.unpack(core(b, bytes.length * 8), false);
		}
		
		/**
		* Computes a HMAC-SHA-256 for the key and bytes.
		* @param key An array of bytes in any encoding.
		* @param bytes An array of bytes in any encoding.
		* @return An array of HMAC-SHA-256 hashed bytes.
		*/
		public static function computeHMAC(key:Array, bytes:Array):Array
		{
			return HMAC.compute(key, bytes, SHA256.compute, 64);
		}
		
		/**
		* Private constants of the class.
		*/
		private static const h:Array = [0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19];
		private static const k:Array = [0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da, 0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070, 0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3, 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2];
		
		/**
		* Private methods of the class.
		*/
		private static function core(x:Array, l:int):Array
		{
			x[l >> 5] |= 0x80 << (24 - l % 32);
			x[((l + 64 >> 9) << 4) + 15] = l;
			var w:Array = [];
			var a:int = h[0], b:int = h[1];
			var c:int = h[2], d:int = h[3];
			var e:int = h[4], f:int = h[5];
			var g:int = h[6], h:int = h[7];
			for (var i:int = 0; i < x.length; i += 16) 
			{
				var olda:int = a, oldb:int = b;
				var oldc:int = c, oldd:int = d;
				var olde:int = e, oldf:int = f;
				var oldg:int = g, oldh:int = h;
				for (var j:int = 0; j < 64; j++) 
				{
					if (j < 16) w[j] = x[i + j] || 0;
					else 
					{
						var s0:int = rrol(w[j - 15], 7) ^ rrol(w[j - 15], 18) ^ (w[j - 15] >>> 3);
						var s1:int = rrol(w[j - 2], 17) ^ rrol(w[j - 2], 19) ^ (w[j - 2] >>> 10);
						w[j] = w[j - 16] + s0 + w[j - 7] + s1;
					}
					var t2:int = (rrol(a, 2) ^ rrol(a, 13) ^ rrol(a, 22)) + ((a & b) ^ (a & c) ^ (b & c));
					var t1:int = h + (rrol(e, 6) ^ rrol(e, 11) ^ rrol(e, 25)) + ((e & f) ^ (g & ~e)) + k[j] + w[j];
					h = g; g = f; f = e; e = d + t1;
					d = c; c = b; b = a; a = t1 + t2;
				}
				a += olda; b += oldb; c += oldc; d += oldd;
				e += olde; f += oldf; g += oldg; h += oldh;
			}
			return [a, b, c, d, e, f, g, h];
		}
		private static function rrol(n:int, c:int):int
		{
			return (n << (32 - c)) | (n >>> c);
		}
		
	}

}
