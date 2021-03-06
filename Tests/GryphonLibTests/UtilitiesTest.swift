//
// Copyright 2018 Vinicius Jorge Vendramini
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

// gryphon output: Bootstrap/UtilitiesTest.kt

#if !GRYPHON
@testable import GryphonLib
import XCTest
#endif

class UtilitiesTest: XCTestCase {
	// gryphon insert: constructor(): super() { }

	public func getClassName() -> String { // gryphon annotation: override
		return "UtilitiesTest"
	}

	/// Tests to be run by the translated Kotlin version.
	public func runAllTests() { // gryphon annotation: override
		testExpandSwiftAbbreviation()
		testFileExtension()
		testChangeExtension()
		testGetExtension()
		testPathOfSwiftASTDumpFile()
		testPathOfKotlinErrorMapFile()
		testGetRelativePath()
		testSplitTypeList()
		testIsInEnvelopingParentheses()
		testGetTypeMapping()
		testReadFile()
		testFileExists()
		testGetCurrentFolder()
		testGetFiles()
		testGetAbsolutePath()
		testParallelMap()
	}

	/// Tests to be run when using Swift on Linux
	static var allTests = [ // gryphon ignore
		("testExpandSwiftAbbreviation", testExpandSwiftAbbreviation),
		("testFileExtension", testFileExtension),
		("testChangeExtension", testChangeExtension),
		("testGetExtension", testGetExtension),
		("testPathOfSwiftASTDumpFile", testPathOfSwiftASTDumpFile),
		("testPathOfKotlinErrorMapFile", testPathOfKotlinErrorMapFile),
		("testGetRelativePath", testGetRelativePath),
		("testSplitTypeList", testSplitTypeList),
		("testIsInEnvelopingParentheses", testIsInEnvelopingParentheses),
		("testGetTypeMapping", testGetTypeMapping),
		("testReadFile", testReadFile),
		("testFileExists", testFileExists),
		("testGetCurrentFolder", testGetCurrentFolder),
		("testGetFiles", testGetFiles),
		("testGetAbsolutePath", testGetAbsolutePath),
		("testParallelMap", testParallelMap),
	]

	// MARK: - Tests
	func testExpandSwiftAbbreviation() {
		XCTAssertEqual(
			Utilities.expandSwiftAbbreviation("source_file"), "Source File")
		XCTAssertEqual(
			Utilities.expandSwiftAbbreviation("import_decl"), "Import Declaration")
		XCTAssertEqual(
			Utilities.expandSwiftAbbreviation("declref_expr"), "Declaration Reference Expression")
        XCTAssertEqual(
            Utilities.expandSwiftAbbreviation("load_expr"), "Load Expression")
        XCTAssertEqual(
            Utilities.expandSwiftAbbreviation("func_decl"), "Function Declaration")
        XCTAssertEqual(
            Utilities.expandSwiftAbbreviation("type_ident"), "Type Identity")
        XCTAssertEqual(
            Utilities.expandSwiftAbbreviation("paren_expr"), "Parentheses Expression")
        XCTAssertEqual(
            Utilities.expandSwiftAbbreviation("brace_stmt"), "Brace Statement")
        XCTAssertEqual(
            Utilities.expandSwiftAbbreviation("var_decl"), "Variable Declaration")
        XCTAssertEqual(
            Utilities.expandSwiftAbbreviation("member_ref_expr"), "Member Reference Expression")
	}

	func testFileExtension() {
		XCTAssertEqual(FileExtension.swiftASTDump.rawValue, "swiftASTDump")
		XCTAssertEqual("fileName".withExtension(.swiftASTDump), "fileName.swiftASTDump")
	}

	func testChangeExtension() {
		XCTAssertEqual(
			Utilities.changeExtension(of: "test.txt", to: .swift),
			"test.swift")
		XCTAssertEqual(
			Utilities.changeExtension(of: "/path/to/test.txt", to: .swift),
			"/path/to/test.swift")
		XCTAssertEqual(
			Utilities.changeExtension(of: "path/to/test.txt", to: .kt),
			"path/to/test.kt")
		XCTAssertEqual(
			Utilities.changeExtension(of: "/path/to/test", to: .xcfilelist),
			"/path/to/test.xcfilelist")
		XCTAssertEqual(
			Utilities.changeExtension(of: "path/to/test", to: .output),
			"path/to/test.output")
	}

    func testGetExtension() {
        XCTAssertEqual(Utilities.getExtension(of: "path/to/test.output"), .output)
        XCTAssertEqual(Utilities.getExtension(of: "test.swift"), .swift)
        XCTAssertEqual(Utilities.getExtension(of: "/path/to/test.kt"), .kt)
    }

    func testPathOfSwiftASTDumpFile() {
		for swiftVersion in TranspilationContext.supportedSwiftVersions {
			XCTAssertEqual(
				SupportingFile.pathOfSwiftASTDumpFile(
					forSwiftFile: "src/path/to/file.swift",
					swiftVersion: swiftVersion),
				".gryphon/ASTDumps-Swift-\(swiftVersion)/src/path/to/file.swiftASTDump")
			XCTAssertEqual(
				SupportingFile.pathOfSwiftASTDumpFile(
					forSwiftFile: "folder/file.swift",
					swiftVersion: swiftVersion),
				".gryphon/ASTDumps-Swift-\(swiftVersion)/folder/file.swiftASTDump")
			XCTAssertEqual(
				SupportingFile.pathOfSwiftASTDumpFile(
					forSwiftFile: "file.swift",
					swiftVersion: swiftVersion),
				".gryphon/ASTDumps-Swift-\(swiftVersion)/file.swiftASTDump")
		}
    }

    func testPathOfKotlinErrorMapFile() {
        XCTAssertEqual(
            SupportingFile.pathOfKotlinErrorMapFile(forKotlinFile: "src/path/to/file.kt"),
            ".gryphon/KotlinErrorMaps/src/path/to/file.kotlinErrorMap")
        XCTAssertEqual(
            SupportingFile.pathOfKotlinErrorMapFile(forKotlinFile: "folder/file.kt"),
            ".gryphon/KotlinErrorMaps/folder/file.kotlinErrorMap")
        XCTAssertEqual(
            SupportingFile.pathOfKotlinErrorMapFile(forKotlinFile: "file.kt"),
            ".gryphon/KotlinErrorMaps/file.kotlinErrorMap")
    }

    func testGetRelativePath() {
        let currentFolder = Utilities.getCurrentFolder()

        XCTAssertEqual(
            "path/to/file.swift",
            Utilities.getRelativePath(forFile: "path/to/file.swift"))
        XCTAssertEqual(
            "path/to/file.swift",
            Utilities.getRelativePath(forFile: currentFolder + "/path/to/file.swift"))
    }

    func testSplitTypeList() {
        XCTAssertEqual(
            Utilities.splitTypeList("Int, Int, Int, Int"),
            ["Int", "Int", "Int", "Int"])
        XCTAssertEqual(
            Utilities.splitTypeList("Int: Int"),
            ["Int", "Int"])
        XCTAssertEqual(
            Utilities.splitTypeList("Int, Box<Int, Int>, Int"),
            ["Int", "Box<Int, Int>", "Int"])
        XCTAssertEqual(
            Utilities.splitTypeList("Int, [Int: Int], Int"),
            ["Int", "[Int: Int]", "Int"])
        XCTAssertEqual(
            Utilities.splitTypeList("Int, (Int, Int), Int"),
            ["Int", "(Int, Int)", "Int"])
        XCTAssertEqual(
            Utilities.splitTypeList("Int: Box<Int, Int>"),
            ["Int", "Box<Int, Int>"])
    }

    func testIsInEnvelopingParentheses() {
        XCTAssert(Utilities.isInEnvelopingParentheses("(Int)"))
        XCTAssert(Utilities.isInEnvelopingParentheses("(Int, Int)"))
        XCTAssert(Utilities.isInEnvelopingParentheses("(Int, (Int))"))
        XCTAssert(Utilities.isInEnvelopingParentheses("((Int), (Int))"))
        XCTAssert(Utilities.isInEnvelopingParentheses("((Int), Int)"))

        XCTAssertFalse(Utilities.isInEnvelopingParentheses("(Int) -> (Int)"))
        XCTAssertFalse(Utilities.isInEnvelopingParentheses("(Int) -> (Int, Int)"))
        XCTAssertFalse(Utilities.isInEnvelopingParentheses("(Int, Int) -> (Int, Int)"))
    }

    func testGetTypeMapping() {
        XCTAssertEqual(Utilities.getTypeMapping(for: "Bool"), "Boolean")
        XCTAssertEqual(Utilities.getTypeMapping(for: "Error"), "Exception")
        XCTAssertEqual(Utilities.getTypeMapping(for: "String.Index"), "Int")
        XCTAssertEqual(Utilities.getTypeMapping(for: "Range<String.Index>"), "IntRange")

        XCTAssertEqual(Utilities.getTypeMapping(for: "Asdf"), nil)
    }

	func testReadFile() {
		do {
			let contents = try Utilities.readFile("Readme.md")
			XCTAssert(contents.contains("Gryphon"))
			XCTAssertFalse(contents.contains("blahblahblah"))
		}
		catch {
			XCTFail("Failed to read file")
		}
	}

	func testFileExists() {
		XCTAssert(Utilities.fileExists(at: "Readme.md"))
		XCTAssertFalse(Utilities.fileExists(at: "foo.txt"))
	}

    func testGetCurrentFolder() {
        XCTAssert(Utilities.getCurrentFolder().hasSuffix("Gryphon"))
    }

    func testGetFiles() {
        let allSwiftFiles = Utilities.getFiles(
            inDirectory: "Sources/GryphonLib",
            withExtension: .swift)
        let someSwiftFiles = Utilities.getFiles(
            ["Utilities", "SharedUtilities"],
            inDirectory: "Sources/GryphonLib",
            withExtension: .swift)
        let kotlinFiles = Utilities.getFiles(
            inDirectory: "Sources/GryphonLib",
            withExtension: .kt)

        XCTAssert(allSwiftFiles.contains { $0.hasSuffix("/Utilities.swift") })
        XCTAssert(allSwiftFiles.contains { $0.hasSuffix("/SharedUtilities.swift") })
        XCTAssert(allSwiftFiles.contains { $0.hasSuffix("/TranspilationPass.swift") })

        XCTAssert(someSwiftFiles.contains { $0.hasSuffix("/Utilities.swift") })
        XCTAssert(someSwiftFiles.contains { $0.hasSuffix("/SharedUtilities.swift") })
        XCTAssert(someSwiftFiles.count == 2)

        XCTAssert(kotlinFiles.isEmpty)
    }

    func testGetAbsolutePath() {
        let file = "Sources/GryphonLib/Utilities.swift"
        let absolutePath = Utilities.getAbsoultePath(forFile: file)

        XCTAssert(absolutePath.hasPrefix("/"))
        XCTAssert(absolutePath.hasSuffix(file))
    }

    func testParallelMap() {
        let array1: List<Int> = []
        let array2: List = [1]
        let array3: List = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        let array4: List = List<Int>([Int](0...10_000)) // gryphon ignore
		// gryphon insert: val array4: List<Int> = (0..10000).map{ it }

		let array1Copy = array1.toList()
        let array2Copy = array2.toList()
        let array3Copy = array3.toList()
        let array4Copy = array4.toList()

        let mappedArray1 = try! array1.parallelMap { $0 * 2 }
        let mappedArray2 = try! array2.parallelMap { $0 * 2 }
        let mappedArray3 = try! array3.parallelMap { $0 * 2 }
        let mappedArray4 = try! array4.parallelMap { $0 * 2 }

        let array4Result = List<Int>([Int](0...10_000)).map { $0 * 2 } // gryphon ignore
		// gryphon insert: val array4Result: List<Int> = (0..10000).map{ it * 2 }

        XCTAssertEqual(array1, array1Copy)
        XCTAssertEqual(array2, array2Copy)
        XCTAssertEqual(array3, array3Copy)
        XCTAssertEqual(array4, array4Copy)

        XCTAssertEqual(mappedArray1, [])
        XCTAssertEqual(mappedArray2, [2])
        XCTAssertEqual(mappedArray3, [2, 4, 6, 8, 10, 12, 14, 16, 18, 20])
        XCTAssertEqual(mappedArray4, array4Result)

        XCTAssertThrowsError(try array3.map { (_: Int) -> Int in throw TestError() })
    }
}
