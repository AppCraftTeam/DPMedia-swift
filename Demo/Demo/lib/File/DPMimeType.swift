//
//  DPDPMimeType.swift
//  Demo
//
//  Created by Дмитрий Поляков on 20.11.2022.
//

import Foundation

public struct DPMimeType {
    
    // MARK: - Props
    init(
        mime: String,
        fileExtension: String,
        fileType: DPFileType,
        bytesCount: Int,
        matches: @escaping ([UInt8], Creator) -> Bool
    ) {
        self.mime = mime
        self.fileExtension = fileExtension
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
    public let fileExtension: String
    public let fileType: DPFileType
    
    private let bytesCount: Int
    private let matches: ([UInt8], Creator) -> Bool

    // MARK: - Methods
    private func matches(bytes: [UInt8], swime: Creator) -> Bool {
        bytes.count >= self.bytesCount && self.matches(bytes, swime)
    }

    public static let all: [DPMimeType] = [
        DPMimeType(
              mime: "audio/aac",
              fileExtension: "aac",
              fileType: .aac,
              bytesCount: 2,
              matches: { bytes, _ in
                  bytes[0...1] == [0xFF, 0xF1]
              }
        ),
        DPMimeType(
              mime: "image/jpeg",
              fileExtension: "jpg",
              fileType: .jpg,
              bytesCount: 3,
              matches: { bytes, _ in
                  bytes[0...2] == [0xFF, 0xD8, 0xFF]
              }
        ),
        DPMimeType(
              mime: "image/png",
              fileExtension: "png",
              fileType: .png,
              bytesCount: 4,
              matches: { bytes, _ in
                bytes[0...3] == [0x89, 0x50, 0x4E, 0x47]
              }
        ),
        DPMimeType(
            mime: "image/gif",
            fileExtension: "gif",
            fileType: .gif,
            bytesCount: 3,
            matches: { bytes, _ in
                bytes[0...2] == [0x47, 0x49, 0x46]
            }
        ),
        DPMimeType(
              mime: "image/webp",
              fileExtension: "webp",
              fileType: .webp,
              bytesCount: 12,
              matches: { bytes, _ in
                  bytes[8...11] == [0x57, 0x45, 0x42, 0x50]
              }
        ),
        DPMimeType(
              mime: "image/flif",
              fileExtension: "flif",
              fileType: .flif,
              bytesCount: 4,
              matches: { bytes, _ in
                  bytes[0...3] == [0x46, 0x4C, 0x49, 0x46]
              }
        ),
        DPMimeType(
              mime: "image/x-canon-cr2",
              fileExtension: "cr2",
              fileType: .cr2,
              bytesCount: 10,
              matches: { bytes, _ in
                  (bytes[0...3] == [0x49, 0x49, 0x2A, 0x00] || bytes[0...3] == [0x4D, 0x4D, 0x00, 0x2A]) &&
                  (bytes[8...9] == [0x43, 0x52])
              }
        ),
        DPMimeType(
              mime: "image/tiff",
              fileExtension: "tif",
              fileType: .tif,
              bytesCount: 4,
              matches: { bytes, _ in
                  (bytes[0...3] == [0x49, 0x49, 0x2A, 0x00]) ||
                  (bytes[0...3] == [0x4D, 0x4D, 0x00, 0x2A])
              }
        ),
        DPMimeType(
              mime: "image/bmp",
              fileExtension: "bmp",
              fileType: .bmp,
              bytesCount: 2,
              matches: { bytes, _ in
                  bytes[0...1] == [0x42, 0x4D]
              }
        ),
        DPMimeType(
              mime: "image/vnd.ms-photo",
              fileExtension: "jxr",
              fileType: .jxr,
              bytesCount: 3,
              matches: { bytes, _ in
                  bytes[0...2] == [0x49, 0x49, 0xBC]
              }
        ),
        DPMimeType(
              mime: "image/vnd.adobe.photoshop",
              fileExtension: "psd",
              fileType: .psd,
              bytesCount: 4,
              matches: { bytes, _ in
                  bytes[0...3] == [0x38, 0x42, 0x50, 0x53]
              }
        ),
        DPMimeType(
              mime: "application/epub+zip",
              fileExtension: "epub",
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
        DPMimeType(
              mime: "application/x-xpinstall",
              fileExtension: "xpi",
              fileType: .xpi,
              bytesCount: 50,
              matches: { bytes, _ in
                  (bytes[0...3] == [0x50, 0x4B, 0x03, 0x04]) &&
                  (bytes[30...49] == [0x4D, 0x45, 0x54, 0x41, 0x2D, 0x49, 0x4E, 0x46, 0x2F, 0x6D, 0x6F, 0x7A, 0x69, 0x6C, 0x6C, 0x61, 0x2E, 0x72, 0x73, 0x61])
              }
        ),
        DPMimeType(
              mime: "application/zip",
              fileExtension: "zip",
              fileType: .zip,
              bytesCount: 50,
              matches: { bytes, _ in
                  (bytes[0...1] == [0x50, 0x4B]) &&
                  (bytes[2] == 0x3 || bytes[2] == 0x5 || bytes[2] == 0x7) &&
                  (bytes[3] == 0x4 || bytes[3] == 0x6 || bytes[3] == 0x8)
              }
        ),
        DPMimeType(
              mime: "application/x-tar",
              fileExtension: "tar",
              fileType: .tar,
              bytesCount: 262,
              matches: { bytes, _ in
                  bytes[257...261] == [0x75, 0x73, 0x74, 0x61, 0x72]
              }
        ),
        DPMimeType(
              mime: "application/x-rar-compressed",
              fileExtension: "rar",
              fileType: .rar,
              bytesCount: 7,
              matches: { bytes, _ in
                  (bytes[0...5] == [0x52, 0x61, 0x72, 0x21, 0x1A, 0x07]) &&
                  (bytes[6] == 0x0 || bytes[6] == 0x1)
              }
        ),
        DPMimeType(
              mime: "application/gzip",
              fileExtension: "gz",
              fileType: .gz,
              bytesCount: 3,
              matches: { bytes, _ in
                  bytes[0...2] == [0x1F, 0x8B, 0x08]
              }
        ),
        DPMimeType(
              mime: "application/x-bzip2",
              fileExtension: "bz2",
              fileType: .bz2,
              bytesCount: 3,
              matches: { bytes, _ in
                  bytes[0...2] == [0x42, 0x5A, 0x68]
              }
        ),
        DPMimeType(
              mime: "application/x-7z-compressed",
              fileExtension: "7z",
              fileType: .sevenZ,
              bytesCount: 6,
              matches: { bytes, _ in
                  bytes[0...5] == [0x37, 0x7A, 0xBC, 0xAF, 0x27, 0x1C]
              }
        ),
        DPMimeType(
              mime: "application/x-apple-diskimage",
              fileExtension: "dmg",
              fileType: .dmg,
              bytesCount: 2,
              matches: { bytes, _ in
                  bytes[0...1] == [0x78, 0x01]
              }
        ),
        DPMimeType(
              mime: "video/mp4",
              fileExtension: "mp4",
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
        DPMimeType(
              mime: "video/x-m4v",
              fileExtension: "m4v",
              fileType: .m4v,
              bytesCount: 11,
              matches: { bytes, _ in
                  bytes[0...10] == [0x00, 0x00, 0x00, 0x1C, 0x66, 0x74, 0x79, 0x70, 0x4D, 0x34, 0x56]
              }
        ),
        DPMimeType(
              mime: "audio/midi",
              fileExtension: "mid",
              fileType: .mid,
              bytesCount: 4,
              matches: { bytes, _ in
                  bytes[0...3] == [0x4D, 0x54, 0x68, 0x64]
              }
        ),
        DPMimeType(
              mime: "video/x-matroska",
              fileExtension: "mkv",
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
        DPMimeType(
              mime: "video/webm",
              fileExtension: "webm",
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
        DPMimeType(
              mime: "video/quicktime",
              fileExtension: "mov",
              fileType: .mov,
              bytesCount: 8,
              matches: { bytes, _ in
                  bytes[0...7] == [0x00, 0x00, 0x00, 0x14, 0x66, 0x74, 0x79, 0x70]
              }
        ),
        DPMimeType(
              mime: "video/x-msvideo",
              fileExtension: "avi",
              fileType: .avi,
              bytesCount: 11,
              matches: { bytes, _ in
                  (bytes[0...3] == [0x52, 0x49, 0x46, 0x46]) &&
                  (bytes[8...10] == [0x41, 0x56, 0x49])
              }
        ),
        DPMimeType(
              mime: "video/x-ms-wmv",
              fileExtension: "wmv",
              fileType: .wmv,
              bytesCount: 10,
              matches: { bytes, _ in
                  bytes[0...9] == [0x30, 0x26, 0xB2, 0x75, 0x8E, 0x66, 0xCF, 0x11, 0xA6, 0xD9]
              }
        ),
        DPMimeType(
              mime: "video/mpeg",
              fileExtension: "mpg",
              fileType: .mpg,
              bytesCount: 4,
              matches: { bytes, _ in
                  guard bytes[0...2] == [0x00, 0x00, 0x01]  else { return false }
                  let hexCode = String(format: "%2X", bytes[3])
                  return hexCode.first != nil && hexCode.first! == "B"
              }
        ),
        DPMimeType(
              mime: "audio/mpeg",
              fileExtension: "mp3",
              fileType: .mp3,
              bytesCount: 3,
              matches: { bytes, _ in
                  (bytes[0...2] == [0x49, 0x44, 0x33]) ||
                  (bytes[0...1] == [0xFF, 0xFB])
              }
        ),
        DPMimeType(
              mime: "audio/m4a",
              fileExtension: "m4a",
              fileType: .m4a,
              bytesCount: 11,
              matches: { bytes, _ in
                  (bytes[0...3] == [0x4D, 0x34, 0x41, 0x20]) ||
                  (bytes[4...10] == [0x66, 0x74, 0x79, 0x70, 0x4D, 0x34, 0x41])
              }
        ),
        DPMimeType(
            mime: "audio/opus",
            fileExtension: "opus",
            fileType: .opus,
            bytesCount: 36,
            matches: { bytes, _ in
                bytes[28...35] == [0x4F, 0x70, 0x75, 0x73, 0x48, 0x65, 0x61, 0x64]
            }
        ),
        DPMimeType(
            mime: "audio/ogg",
            fileExtension: "ogg",
            fileType: .ogg,
            bytesCount: 4,
            matches: { bytes, _ in
                bytes[0...3] == [0x4F, 0x67, 0x67, 0x53]
            }
        ),
        DPMimeType(
            mime: "audio/x-flac",
            fileExtension: "flac",
            fileType: .flac,
            bytesCount: 4,
            matches: { bytes, _ in
                bytes[0...3] == [0x66, 0x4C, 0x61, 0x43]
            }
        ),
        DPMimeType(
            mime: "audio/x-wav",
            fileExtension: "wav",
            fileType: .wav,
            bytesCount: 12,
            matches: { bytes, _ in
                (bytes[0...3] == [0x52, 0x49, 0x46, 0x46]) &&
                (bytes[8...11] == [0x57, 0x41, 0x56, 0x45])
            }
        ),
        DPMimeType(
            mime: "audio/amr",
            fileExtension: "amr",
            fileType: .amr,
            bytesCount: 6,
            matches: { bytes, _ in
                bytes[0...5] == [0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A]
            }
        ),
        DPMimeType(
            mime: "application/pdf",
            fileExtension: "pdf",
            fileType: .pdf,
            bytesCount: 4,
            matches: { bytes, _ in
                bytes[0...3] == [0x25, 0x50, 0x44, 0x46]
            }
        ),
        DPMimeType(
            mime: "application/x-msdownload",
            fileExtension: "exe",
            fileType: .exe,
            bytesCount: 2,
            matches: { bytes, _ in
                bytes[0...1] == [0x4D, 0x5A]
            }
        ),
        DPMimeType(
            mime: "application/x-shockwave-flash",
            fileExtension: "swf",
            fileType: .swf,
            bytesCount: 3,
            matches: { bytes, _ in
                (bytes[0] == 0x43 || bytes[0] == 0x46) && (bytes[1...2] == [0x57, 0x53])
            }
        ),
        DPMimeType(
            mime: "application/rtf",
            fileExtension: "rtf",
            fileType: .rtf,
            bytesCount: 5,
            matches: { bytes, _ in
                bytes[0...4] == [0x7B, 0x5C, 0x72, 0x74, 0x66]
            }
        ),
        DPMimeType(
            mime: "application/font-woff",
            fileExtension: "woff",
            fileType: .woff,
            bytesCount: 8,
            matches: { bytes, _ in
                (bytes[0...3] == [0x77, 0x4F, 0x46, 0x46]) &&
                ((bytes[4...7] == [0x00, 0x01, 0x00, 0x00]) || (bytes[4...7] == [0x4F, 0x54, 0x54, 0x4F]))
            }
        ),
        DPMimeType(
            mime: "application/font-woff",
            fileExtension: "woff2",
            fileType: .woff2,
            bytesCount: 8,
            matches: { bytes, _ in
                (bytes[0...3] == [0x77, 0x4F, 0x46,  0x32]) &&
                ((bytes[4...7] == [0x00, 0x01, 0x00, 0x00]) || (bytes[4...7] == [0x4F, 0x54, 0x54, 0x4F]))
            }
        ),
        DPMimeType(
            mime: "application/vnd.ms-fontobject",
            fileExtension: "eot",
            fileType: .eot,
            bytesCount: 82,
            matches: { bytes, _ in
                bytes[34...35] == [0x4c, 0x50] &&
                Array(bytes[64...79]) == Array(repeating: 0x00, count: 16) &&
                bytes[82] != 0x00
            }
        ),
        DPMimeType(
            mime: "application/font-sfnt",
            fileExtension: "ttf",
            fileType: .ttf,
            bytesCount: 5,
            matches: { bytes, _ in
                bytes[0...4] == [0x00, 0x01, 0x00, 0x00, 0x00]
            }
        ),
        DPMimeType(
            mime: "application/font-sfnt",
            fileExtension: "otf",
            fileType: .otf,
            bytesCount: 5,
            matches: { bytes, _ in
                bytes[0...4] == [0x4F, 0x54, 0x54, 0x4F, 0x00]
            }
        ),
        DPMimeType(
            mime: "image/x-icon",
            fileExtension: "ico",
            fileType: .ico,
            bytesCount: 4,
            matches: { bytes, _ in
                bytes[0...3] == [0x00, 0x00, 0x01, 0x00]
            }
        ),
        DPMimeType(
            mime: "video/x-flv",
            fileExtension: "flv",
            fileType: .flv,
            bytesCount: 4,
            matches: { bytes, _ in
                bytes[0...3] == [0x46, 0x4C, 0x56, 0x01]
            }
        ),
        DPMimeType(
            mime: "application/postscript",
            fileExtension: "ps",
            fileType: .ps,
            bytesCount: 2,
            matches: { bytes, _ in
                bytes[0...1] == [0x25, 0x21]
            }
        ),
        DPMimeType(
            mime: "application/x-xz",
            fileExtension: "xz",
            fileType: .xz,
            bytesCount: 6,
            matches: { bytes, _ in
                bytes[0...5] == [0xFD, 0x37, 0x7A, 0x58, 0x5A, 0x00]
            }
        ),
        DPMimeType(
            mime: "application/x-sqlite3",
            fileExtension: "sqlite",
            fileType: .sqlite,
            bytesCount: 4,
            matches: { bytes, _ in
                bytes[0...3] == [0x53, 0x51, 0x4C, 0x69]
            }
        ),
        DPMimeType(
            mime: "application/x-nintendo-nes-rom",
            fileExtension: "nes",
            fileType: .nes,
            bytesCount: 4,
            matches: { bytes, _ in
                bytes[0...3] == [0x4E, 0x45, 0x53, 0x1A]
            }
        ),
        DPMimeType(
            mime: "application/x-google-chrome-extension",
            fileExtension: "crx",
            fileType: .crx,
            bytesCount: 4,
            matches: { bytes, _ in
                bytes[0...3] == [0x43, 0x72, 0x32, 0x34]
            }
        ),
        DPMimeType(
            mime: "application/vnd.ms-cab-compressed",
            fileExtension: "cab",
            fileType: .cab,
            bytesCount: 4,
            matches: { bytes, _ in
                (bytes[0...3] == [0x4D, 0x53, 0x43, 0x46]) || (bytes[0...3] == [0x49, 0x53, 0x63, 0x28])
            }
        ),
        DPMimeType(
            mime: "application/x-deb",
            fileExtension: "deb",
            fileType: .deb,
            bytesCount: 21,
            matches: { bytes, _ in
                bytes[0...20] == [0x21, 0x3C, 0x61, 0x72, 0x63, 0x68, 0x3E, 0x0A, 0x64, 0x65, 0x62, 0x69, 0x61, 0x6E, 0x2D, 0x62, 0x69, 0x6E, 0x61, 0x72, 0x79]
            }
        ),
        DPMimeType(
            mime: "application/x-unix-archive",
            fileExtension: "ar",
            fileType: .ar,
            bytesCount: 7,
            matches: { bytes, _ in
                bytes[0...6] == [0x21, 0x3C, 0x61, 0x72, 0x63, 0x68, 0x3E]
            }
        ),
        DPMimeType(
            mime: "application/x-rpm",
            fileExtension: "rpm",
            fileType: .rpm,
            bytesCount: 4,
            matches: { bytes, _ in
                bytes[0...3] == [0xED, 0xAB, 0xEE, 0xDB]
            }
        ),
        DPMimeType(
            mime: "application/x-compress",
            fileExtension: "Z",
            fileType: .z,
            bytesCount: 2,
            matches: { bytes, _ in
                (bytes[0...1] == [0x1F, 0xA0]) || (bytes[0...1] == [0x1F, 0x9D])
            }
        ),
        DPMimeType(
            mime: "application/x-lzip",
            fileExtension: "lz",
            fileType: .lz,
            bytesCount: 4,
            matches: { bytes, _ in
                bytes[0...3] == [0x4C, 0x5A, 0x49, 0x50]
            }
        ),
        DPMimeType(
            mime: "application/x-msi",
            fileExtension: "msi",
            fileType: .msi,
            bytesCount: 8,
            matches: { bytes, _ in
                bytes[0...7] == [0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1]
            }
        ),
        DPMimeType(
            mime: "application/mxf",
            fileExtension: "mxf",
            fileType: .mxf,
            bytesCount: 14,
            matches: { bytes, _ in
                bytes[0...13] == [0x06, 0x0E, 0x2B, 0x34, 0x02, 0x05, 0x01, 0x01, 0x0D, 0x01, 0x02, 0x01, 0x01, 0x02 ]
            }
        ),
        DPMimeType(
            mime: "application/heic",
            fileExtension: "heic",
            fileType: .heic,
            bytesCount: 12,
            matches: { bytes, _ in
                bytes[8...11] == [0x68, 0x65, 0x69, 0x63] || bytes[8...11] == [0x68, 0x65, 0x69, 0x78]
            }
        )
    ]
    
}

// MARK: - Creator
extension DPMimeType {
    
    struct Creator {

        // MARK: - Init
        public init(data: Data) {
            self.data = data
        }
        
        // MARK: - Props
        let data: Data
        
        // MARK: - Methods
        func mimeType() -> DPMimeType? {
            let bytes = self.readBytes(count: min(self.data.count, 262))
            
            for mime in DPMimeType.all {
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
