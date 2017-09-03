// Copyright (c) 2017 Timofey Solomko
// Licensed under MIT License
//
// See LICENSE for license information

import Foundation

class EncodingHuffmanTree {

    private var bitWriter: BitWriter

    private var codingIndices: [[Int]]

    /// `lengths` don't have to be properly sorted.
    init(lengths: [HuffmanLength], _ bitWriter: BitWriter) {
        self.bitWriter = bitWriter

        // Sort `lengths` array to calculate canonical Huffman code.
        let sortedLengths = lengths.filter { $0.codeLength > 0 }.sorted { (left: HuffmanLength, right: HuffmanLength) -> Bool in
            if left.codeLength == right.codeLength {
                return left.symbol < right.symbol
            } else {
                return left.codeLength < right.codeLength
            }
        }

        func reverse(bits: Int, in symbol: Int) -> Int {
            // Auxiliarly function, which generates reversed order of bits in a number.
            var a = 1 << 0
            var b = 1 << (bits - 1)
            var z = 0
            for i in stride(from: bits - 1, to: -1, by: -2) {
                z |= (symbol >> i) & a
                z |= (symbol << i) & b
                a <<= 1
                b >>= 1
            }
            return z
        }

        self.codingIndices = Array(repeating: [-1, -1], count: sortedLengths.count)

        // Calculates symbols for each length in 'sortedLengths' array and put them in the tree.
        var loopBits = -1
        var symbol = -1
        for length in sortedLengths {
            symbol += 1
            // We sometimes need to make symbol to have length.bits bit length.
            let bits = length.codeLength
            if bits != loopBits {
                symbol <<= (bits - loopBits)
                loopBits = bits
            }
            // Then we need to reverse bit order of the symbol.
            let treeCode = reverse(bits: loopBits, in: symbol)
            self.codingIndices[length.symbol] = [treeCode, bits]
        }
    }

    func code(symbol: Int) {
        guard symbol < self.codingIndices.count
            else { fatalError("Symbol is not found.") }

        let codingIndex = self.codingIndices[symbol]

        guard codingIndex[0] > -1
            else { fatalError("Symbol is not found.") }

        var treeCode = codingIndex[0]
        let bits = codingIndex[1]

        for _ in 0..<bits {
            let bit = treeCode & 1
            self.bitWriter.write(bit: bit == 0 ? 0 : 1)
            treeCode >>= 1
        }
    }

    func bitSize(for stats: [(Int, Int)]) -> Int {
        var totalSize = 0
        for (symbol, count) in stats where count > 0 {
            guard symbol < self.codingIndices.count
                else { fatalError("Symbol is not found.") }
            let codingIndex = self.codingIndices[symbol]
            guard codingIndex[0] > -1
                else { fatalError("Symbol is not found.") }

            totalSize += count * codingIndex[1]
        }
        return totalSize
    }

}
