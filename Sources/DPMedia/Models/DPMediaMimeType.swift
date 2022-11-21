//
//  DPDPMimeType.swift
//  Demo
//
//  Created by Дмитрий Поляков on 20.11.2022.
//

import Foundation

public struct DPMediaMimeType {
    
    // MARK: - Props
    init(
        mime: String,
        fileType: DPMediaFileType,
        bytesCount: Int,
        matches: @escaping ([UInt8], Creator) -> Bool
    ) {
        self.mime = mime
        self.fileType = fileType
        self.bytesCount = bytesCount
        self.matches = matches
    }
    
    public init?(data: Data) {
        guard let mimeType = Creator(data: data).mimeType() else { return nil }
        self = mimeType
    }
    
    // MARK: - Props
    public let mime: String
    public let fileType: DPMediaFileType
    
    private let bytesCount: Int
    private let matches: ([UInt8], Creator) -> Bool

    // MARK: - Methods
    private func matches(bytes: [UInt8], swime: Creator) -> Bool {
        bytes.count >= self.bytesCount && self.matches(bytes, swime)
    }

    public static let all: [DPMediaMimeType] = [
        DPMediaMimeType(
              mime: "audio/aac",
              fileType: .aac,
              bytesCount: 2,
              matches: { bytes, _ in
                  bytes[0...1] == [0xFF, 0xF1]
              }
        ),
        DPMediaMimeType(
              mime: "image/jpeg",
              fileType: .jpg,
              bytesCount: 3,
              matches: { bytes, _ in
                  bytes[0...2] == [0xFF, 0xD8, 0xFF]
              }
        ),
        DPMediaMimeType(
              mime: "image/png",
              fileType: .png,
              bytesCount: 4,
              matches: { bytes, _ in
                bytes[0...3] == [0x89, 0x50, 0x4E, 0x47]
              }
        ),
        DPMediaMimeType(
            mime: "image/gif",
            fileType: .gif,
            bytesCount: 3,
            matches: { bytes, _ in
                bytes[0...2] == [0x47, 0x49, 0x46]
            }
        ),
        DPMediaMimeType(
              mime: "image/webp",
              fileType: .webp,
              bytesCount: 12,
              matches: { bytes, _ in
                  bytes[8...11] == [0x57, 0x45, 0x42, 0x50]
              }
        ),
        DPMediaMimeType(
              mime: "image/flif",
              fileType: .flif,
              bytesCount: 4,
              matches: { bytes, _ in
                  bytes[0...3] == [0x46, 0x4C, 0x49, 0x46]
              }
        ),
        DPMediaMimeType(
              mime: "image/x-canon-cr2",
              fileType: .cr2,
              bytesCount: 10,
              matches: { bytes, _ in
                  (bytes[0...3] == [0x49, 0x49, 0x2A, 0x00] || bytes[0...3] == [0x4D, 0x4D, 0x00, 0x2A]) &&
                  (bytes[8...9] == [0x43, 0x52])
              }
        ),
        DPMediaMimeType(
              mime: "image/tiff",
              fileType: .tif,
              bytesCount: 4,
              matches: { bytes, _ in
                  (bytes[0...3] == [0x49, 0x49, 0x2A, 0x00]) ||
                  (bytes[0...3] == [0x4D, 0x4D, 0x00, 0x2A])
              }
        ),
        DPMediaMimeType(
              mime: "image/bmp",
              fileType: .bmp,
              bytesCount: 2,
              matches: { bytes, _ in
                  bytes[0...1] == [0x42, 0x4D]
              }
        ),
        DPMediaMimeType(
              mime: "image/vnd.ms-photo",
              fileType: .jxr,
              bytesCount: 3,
              matches: { bytes, _ in
                  bytes[0...2] == [0x49, 0x49, 0xBC]
              }
        ),
        DPMediaMimeType(
              mime: "image/vnd.adobe.photoshop",
              fileType: .psd,
              bytesCount: 4,
              matches: { bytes, _ in
                  bytes[0...3] == [0x38, 0x42, 0x50, 0x53]
              }
        ),
        DPMediaMimeType(
              mime: "application/epub+zip",
              fileType: .epub,
              bytesCount: 58,
              matches: { bytes, _ in
                  (bytes[0...3] == [0x50, 0x4B, 0x03, 0x04]) &&
                  (bytes[30...57] == [
                    0x6D, 0x69, 0x6D, 0x65, 0x74, 0x79, 0x70, 0x65, 0x61, 0x70, 0x70, 0x6C,
                    0x69, 0x63, 0x61, 0x74, 0x69, 0x6F, 0x6E, 0x2F, 0x65, 0x70, 0x75, 0x62,
                    0x2B, 0x7A, 0x69, 0x70
                  ])
              }
        ),
        DPMediaMimeType(
              mime: "application/x-xpinstall",
              fileType: .xpi,
              bytesCount: 50,
              matches: { bytes, _ in
                  (bytes[0...3] == [0x50, 0x4B, 0x03, 0x04]) &&
                  (bytes[30...49] == [0x4D, 0x45, 0x54, 0x41, 0x2D, 0x49, 0x4E, 0x46, 0x2F, 0x6D, 0x6F, 0x7A, 0x69, 0x6C, 0x6C, 0x61, 0x2E, 0x72, 0x73, 0x61])
              }
        ),
        DPMediaMimeType(
              mime: "application/zip",
              fileType: .zip,
              bytesCount: 50,
              matches: { bytes, _ in
                  (bytes[0...1] == [0x50, 0x4B]) &&
                  (bytes[2] == 0x3 || bytes[2] == 0x5 || bytes[2] == 0x7) &&
                  (bytes[3] == 0x4 || bytes[3] == 0x6 || bytes[3] == 0x8)
              }
        ),
        DPMediaMimeType(
              mime: "application/x-tar",
              fileType: .tar,
              bytesCount: 262,
              matches: { bytes, _ in
                  bytes[257...261] == [0x75, 0x73, 0x74, 0x61, 0x72]
              }
        ),
        DPMediaMimeType(
              mime: "application/x-rar-compressed",
              fileType: .rar,
              bytesCount: 7,
              matches: { bytes, _ in
                  (bytes[0...5] == [0x52, 0x61, 0x72, 0x21, 0x1A, 0x07]) &&
                  (bytes[6] == 0x0 || bytes[6] == 0x1)
              }
        ),
        DPMediaMimeType(
              mime: "application/gzip",
              fileType: .gz,
              bytesCount: 3,
              matches: { bytes, _ in
                  bytes[0...2] == [0x1F, 0x8B, 0x08]
              }
        ),
        DPMediaMimeType(
              mime: "application/x-bzip2",
              fileType: .bz2,
              bytesCount: 3,
              matches: { bytes, _ in
                  bytes[0...2] == [0x42, 0x5A, 0x68]
              }
        ),
        DPMediaMimeType(
              mime: "application/x-7z-compressed",
              fileType: .sevenZ,
              bytesCount: 6,
              matches: { bytes, _ in
                  bytes[0...5] == [0x37, 0x7A, 0xBC, 0xAF, 0x27, 0x1C]
              }
        ),
        DPMediaMimeType(
              mime: "application/x-apple-diskimage",
              fileType: .dmg,
              bytesCount: 2,
              matches: { bytes, _ in
                  bytes[0...1] == [0x78, 0x01]
              }
        ),
        DPMediaMimeType(
              mime: "video/mp4",
              fileType: .mp4,
              bytesCount: 28,
              matches: { bytes, _ in
                  (bytes[0...2] == [0x00, 0x00, 0x00] && (bytes[3] == 0x18 || bytes[3] == 0x20) && bytes[4...7] == [0x66, 0x74, 0x79, 0x70]) ||
                  (bytes[0...3] == [0x33, 0x67, 0x70, 0x35]) ||
                  (bytes[0...11] == [0x00, 0x00, 0x00, 0x1C, 0x66, 0x74, 0x79, 0x70, 0x6D, 0x70, 0x34, 0x32] &&
                    bytes[16...27] == [0x6D, 0x70, 0x34, 0x31, 0x6D, 0x70, 0x34, 0x32, 0x69, 0x73, 0x6F, 0x6D]) ||
                  (bytes[0...11] == [0x00, 0x00, 0x00, 0x1C, 0x66, 0x74, 0x79, 0x70, 0x69, 0x73, 0x6F, 0x6D]) ||
                  (bytes[0...11] == [0x00, 0x00, 0x00, 0x1C, 0x66, 0x74, 0x79, 0x70, 0x6D, 0x70, 0x34, 0x32])
              }
        ),
        DPMediaMimeType(
              mime: "video/x-m4v",
              fileType: .m4v,
              bytesCount: 11,
              matches: { bytes, _ in
                  bytes[0...10] == [0x00, 0x00, 0x00, 0x1C, 0x66, 0x74, 0x79, 0x70, 0x4D, 0x34, 0x56]
              }
        ),
        DPMediaMimeType(
              mime: "audio/midi",
              fileType: .mid,
              bytesCount: 4,
              matches: { bytes, _ in
                  bytes[0...3] == [0x4D, 0x54, 0x68, 0x64]
              }
        ),
        DPMediaMimeType(
              mime: "video/x-matroska",
              fileType: .mkv,
              bytesCount: 4,
              matches: { bytes, swime in
                  guard bytes[0...3] == [0x1A, 0x45, 0xDF, 0xA3] else { return false }
                  let _bytes = Array(swime.readBytes(count: 4100)[4 ..< 4100])
                  var idPos = -1

                    for i in 0 ..< (_bytes.count - 1) {
                        if _bytes[i] == 0x42 && _bytes[i + 1] == 0x82 {
                            idPos = i
                            break
                        }
                    }

                  guard idPos > -1 else { return false }
                  let docTypePos = idPos + 3
                  
                  let findDocType: (String) -> Bool = { type in
                      for i in 0 ..< type.count {
                          let index = type.index(type.startIndex, offsetBy: i)
                          let scalars = String(type[index]).unicodeScalars

                          if _bytes[docTypePos + i] != UInt8(scalars[scalars.startIndex].value) {
                              return false
                          }
                      }

                      return true
                  }
                  
                  return findDocType("matroska")
            }
        ),
        DPMediaMimeType(
              mime: "video/webm",
              fileType: .webm,
              bytesCount: 4,
              matches: { bytes, swime in
                  guard bytes[0...3] == [0x1A, 0x45, 0xDF, 0xA3] else { return false }
                  let _bytes = Array(swime.readBytes(count: 4100)[4 ..< 4100])
                  var idPos = -1

                  for i in 0 ..< (_bytes.count - 1) {
                      if _bytes[i] == 0x42 && _bytes[i + 1] == 0x82 {
                          idPos = i
                          break
                      }
                  }

                  guard idPos > -1 else { return false }
                  let docTypePos = idPos + 3
                  
                  let findDocType: (String) -> Bool = { type in
                      for i in 0 ..< type.count {
                          let index = type.index(type.startIndex, offsetBy: i)
                          let scalars = String(type[index]).unicodeScalars

                          if _bytes[docTypePos + i] != UInt8(scalars[scalars.startIndex].value) {
                              return false
                          }
                      }
                      return true
                  }

                  return findDocType("webm")
              }
        ),
        DPMediaMimeType(
              mime: "video/quicktime",
              fileType: .mov,
              bytesCount: 8,
              matches: { bytes, _ in
                  bytes[0...7] == [0x00, 0x00, 0x00, 0x14, 0x66, 0x74, 0x79, 0x70]
              }
        ),
        DPMediaMimeType(
              mime: "video/x-msvideo",
              fileType: .avi,
              bytesCount: 11,
              matches: { bytes, _ in
                  (bytes[0...3] == [0x52, 0x49, 0x46, 0x46]) &&
                  (bytes[8...10] == [0x41, 0x56, 0x49])
              }
        ),
        DPMediaMimeType(
              mime: "video/x-ms-wmv",
              fileType: .wmv,
              bytesCount: 10,
              matches: { bytes, _ in
                  bytes[0...9] == [0x30, 0x26, 0xB2, 0x75, 0x8E, 0x66, 0xCF, 0x11, 0xA6, 0xD9]
              }
        ),
        DPMediaMimeType(
              mime: "video/mpeg",
              fileType: .mpg,
              bytesCount: 4,
              matches: { bytes, _ in
                  guard bytes[0...2] == [0x00, 0x00, 0x01]  else { return false }
                  let hexCode = String(format: "%2X", bytes[3])
                  return hexCode.first != nil && hexCode.first! == "B"
              }
        ),
        DPMediaMimeType(
              mime: "audio/mpeg",
              fileType: .mp3,
              bytesCount: 3,
              matches: { bytes, _ in
                  (bytes[0...2] == [0x49, 0x44, 0x33]) ||
                  (bytes[0...1] == [0xFF, 0xFB])
              }
        ),
        DPMediaMimeType(
              mime: "audio/m4a",
              fileType: .m4a,
              bytesCount: 11,
              matches: { bytes, _ in
                  (bytes[0...3] == [0x4D, 0x34, 0x41, 0x20]) ||
                  (bytes[4...10] == [0x66, 0x74, 0x79, 0x70, 0x4D, 0x34, 0x41])
              }
        ),
        DPMediaMimeType(
            mime: "audio/opus",
            fileType: .opus,
            bytesCount: 36,
            matches: { bytes, _ in
                bytes[28...35] == [0x4F, 0x70, 0x75, 0x73, 0x48, 0x65, 0x61, 0x64]
            }
        ),
        DPMediaMimeType(
            mime: "audio/ogg",
            fileType: .ogg,
            bytesCount: 4,
            matches: { bytes, _ in
                bytes[0...3] == [0x4F, 0x67, 0x67, 0x53]
            }
        ),
        DPMediaMimeType(
            mime: "audio/x-flac",
            fileType: .flac,
            bytesCount: 4,
            matches: { bytes, _ in
                bytes[0...3] == [0x66, 0x4C, 0x61, 0x43]
            }
        ),
        DPMediaMimeType(
            mime: "audio/x-wav",
            fileType: .wav,
            bytesCount: 12,
            matches: { bytes, _ in
                (bytes[0...3] == [0x52, 0x49, 0x46, 0x46]) &&
                (bytes[8...11] == [0x57, 0x41, 0x56, 0x45])
            }
        ),
        DPMediaMimeType(
            mime: "audio/amr",
            fileType: .amr,
            bytesCount: 6,
            matches: { bytes, _ in
                bytes[0...5] == [0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A]
            }
        ),
        DPMediaMimeType(
            mime: "application/pdf",
            fileType: .pdf,
            bytesCount: 4,
            matches: { bytes, _ in
                bytes[0...3] == [0x25, 0x50, 0x44, 0x46]
            }
        ),
        DPMediaMimeType(
            mime: "application/x-msdownload",
            fileType: .exe,
            bytesCount: 2,
            matches: { bytes, _ in
                bytes[0...1] == [0x4D, 0x5A]
            }
        ),
        DPMediaMimeType(
            mime: "application/x-shockwave-flash",
            fileType: .swf,
            bytesCount: 3,
            matches: { bytes, _ in
                (bytes[0] == 0x43 || bytes[0] == 0x46) && (bytes[1...2] == [0x57, 0x53])
            }
        ),
        DPMediaMimeType(
            mime: "application/rtf",
            fileType: .rtf,
            bytesCount: 5,
            matches: { bytes, _ in
                bytes[0...4] == [0x7B, 0x5C, 0x72, 0x74, 0x66]
            }
        ),
        DPMediaMimeType(
            mime: "application/font-woff",
            fileType: .woff,
            bytesCount: 8,
            matches: { bytes, _ in
                (bytes[0...3] == [0x77, 0x4F, 0x46, 0x46]) &&
                ((bytes[4...7] == [0x00, 0x01, 0x00, 0x00]) || (bytes[4...7] == [0x4F, 0x54, 0x54, 0x4F]))
            }
        ),
        DPMediaMimeType(
            mime: "application/font-woff",
            fileType: .woff2,
            bytesCount: 8,
            matches: { bytes, _ in
                (bytes[0...3] == [0x77, 0x4F, 0x46,  0x32]) &&
                ((bytes[4...7] == [0x00, 0x01, 0x00, 0x00]) || (bytes[4...7] == [0x4F, 0x54, 0x54, 0x4F]))
            }
        ),
        DPMediaMimeType(
            mime: "application/vnd.ms-fontobject",
            fileType: .eot,
            bytesCount: 82,
            matches: { bytes, _ in
                bytes[34...35] == [0x4c, 0x50] &&
                Array(bytes[64...79]) == Array(repeating: 0x00, count: 16) &&
                bytes[82] != 0x00
            }
        ),
        DPMediaMimeType(
            mime: "application/font-sfnt",
            fileType: .ttf,
            bytesCount: 5,
            matches: { bytes, _ in
                bytes[0...4] == [0x00, 0x01, 0x00, 0x00, 0x00]
            }
        ),
        DPMediaMimeType(
            mime: "application/font-sfnt",
            fileType: .otf,
            bytesCount: 5,
            matches: { bytes, _ in
                bytes[0...4] == [0x4F, 0x54, 0x54, 0x4F, 0x00]
            }
        ),
        DPMediaMimeType(
            mime: "image/x-icon",
            fileType: .ico,
            bytesCount: 4,
            matches: { bytes, _ in
                bytes[0...3] == [0x00, 0x00, 0x01, 0x00]
            }
        ),
        DPMediaMimeType(
            mime: "video/x-flv",
            fileType: .flv,
            bytesCount: 4,
            matches: { bytes, _ in
                bytes[0...3] == [0x46, 0x4C, 0x56, 0x01]
            }
        ),
        DPMediaMimeType(
            mime: "application/postscript",
            fileType: .ps,
            bytesCount: 2,
            matches: { bytes, _ in
                bytes[0...1] == [0x25, 0x21]
            }
        ),
        DPMediaMimeType(
            mime: "application/x-xz",
            fileType: .xz,
            bytesCount: 6,
            matches: { bytes, _ in
                bytes[0...5] == [0xFD, 0x37, 0x7A, 0x58, 0x5A, 0x00]
            }
        ),
        DPMediaMimeType(
            mime: "application/x-sqlite3",
            fileType: .sqlite,
            bytesCount: 4,
            matches: { bytes, _ in
                bytes[0...3] == [0x53, 0x51, 0x4C, 0x69]
            }
        ),
        DPMediaMimeType(
            mime: "application/x-nintendo-nes-rom",
            fileType: .nes,
            bytesCount: 4,
            matches: { bytes, _ in
                bytes[0...3] == [0x4E, 0x45, 0x53, 0x1A]
            }
        ),
        DPMediaMimeType(
            mime: "application/x-google-chrome-extension",
            fileType: .crx,
            bytesCount: 4,
            matches: { bytes, _ in
                bytes[0...3] == [0x43, 0x72, 0x32, 0x34]
            }
        ),
        DPMediaMimeType(
            mime: "application/vnd.ms-cab-compressed",
            fileType: .cab,
            bytesCount: 4,
            matches: { bytes, _ in
                (bytes[0...3] == [0x4D, 0x53, 0x43, 0x46]) || (bytes[0...3] == [0x49, 0x53, 0x63, 0x28])
            }
        ),
        DPMediaMimeType(
            mime: "application/x-deb",
            fileType: .deb,
            bytesCount: 21,
            matches: { bytes, _ in
                bytes[0...20] == [0x21, 0x3C, 0x61, 0x72, 0x63, 0x68, 0x3E, 0x0A, 0x64, 0x65, 0x62, 0x69, 0x61, 0x6E, 0x2D, 0x62, 0x69, 0x6E, 0x61, 0x72, 0x79]
            }
        ),
        DPMediaMimeType(
            mime: "application/x-unix-archive",
            fileType: .ar,
            bytesCount: 7,
            matches: { bytes, _ in
                bytes[0...6] == [0x21, 0x3C, 0x61, 0x72, 0x63, 0x68, 0x3E]
            }
        ),
        DPMediaMimeType(
            mime: "application/x-rpm",
            fileType: .rpm,
            bytesCount: 4,
            matches: { bytes, _ in
                bytes[0...3] == [0xED, 0xAB, 0xEE, 0xDB]
            }
        ),
        DPMediaMimeType(
            mime: "application/x-compress",
            fileType: .z,
            bytesCount: 2,
            matches: { bytes, _ in
                (bytes[0...1] == [0x1F, 0xA0]) || (bytes[0...1] == [0x1F, 0x9D])
            }
        ),
        DPMediaMimeType(
            mime: "application/x-lzip",
            fileType: .lz,
            bytesCount: 4,
            matches: { bytes, _ in
                bytes[0...3] == [0x4C, 0x5A, 0x49, 0x50]
            }
        ),
        DPMediaMimeType(
            mime: "application/x-msi",
            fileType: .msi,
            bytesCount: 8,
            matches: { bytes, _ in
                bytes[0...7] == [0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1]
            }
        ),
        DPMediaMimeType(
            mime: "application/mxf",
            fileType: .mxf,
            bytesCount: 14,
            matches: { bytes, _ in
                bytes[0...13] == [0x06, 0x0E, 0x2B, 0x34, 0x02, 0x05, 0x01, 0x01, 0x0D, 0x01, 0x02, 0x01, 0x01, 0x02 ]
            }
        ),
        DPMediaMimeType(
            mime: "application/heic",
            fileType: .heic,
            bytesCount: 12,
            matches: { bytes, _ in
                bytes[8...11] == [0x68, 0x65, 0x69, 0x63] || bytes[8...11] == [0x68, 0x65, 0x69, 0x78]
            }
        )
    ]
    
}

// MARK: - Creator
extension DPMediaMimeType {
    
    struct Creator {

        // MARK: - Init
        public init(data: Data) {
            self.data = data
        }
        
        // MARK: - Props
        let data: Data
        
        // MARK: - Methods
        func mimeType() -> DPMediaMimeType? {
            let bytes = self.readBytes(count: min(self.data.count, 262))
            
            for mime in DPMediaMimeType.all {
                guard mime.matches(bytes: bytes, swime: self) else { continue }
                return mime
            }

            return nil
        }

        func readBytes(count: Int) -> [UInt8] {
            var bytes = [UInt8](repeating: 0, count: count)
            self.data.copyBytes(to: &bytes, count: count)
            return bytes
        }
        
    }
    
}
