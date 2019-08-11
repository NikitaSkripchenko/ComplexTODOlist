import Foundation

public class FileNotebook {
    var notes: [Note] = [Note]()
    public private(set) var imageNotes = [ImageNote]()

    public func add(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.uid == note.uid }) {
            notes[index] = note
        } else {
            notes.append(note)
        }
    }
    
    public func add(_ imageNote: ImageNote){
        if let index = imageNotes.firstIndex(where: {$0.uid == imageNote.uid}){
            imageNotes[index] = imageNote
        }else{
            imageNotes.append(imageNote)
        }
    }

    public func replaceAll(notes: [Note]) {
        self.notes = notes
    }

    public func remove(with uid: String) {
        if let index = self.notes.firstIndex(where: { $0.uid == uid }){
            self.notes.remove(at: index)
        }
    }
    
    public func removeImage(with uid: String){
        if let index = imageNotes.firstIndex(where: {$0.uid == uid}){
            imageNotes.remove(at: index)
        }
    }

    public func saveToFile() {
        guard let fileUrl = getFileNotebookPath() else {
            return
        }
        
        var jsonArrayNotes = [[String: Any]]()
        for note in notes {
            jsonArrayNotes.append(note.json)
        }
        
        do {
            let jsdata = try JSONSerialization.data(withJSONObject: jsonArrayNotes, options: [])
            try jsdata.write(to: fileUrl)
        } catch {
        }
    }

    public func loadFromFile() {
        guard let fileUrl = getFileNotebookPath() else {
            
            return
        }
        
        do {
            guard let jsData = try String(contentsOf: fileUrl).data(using: .utf8) else { return }
            
            let anyJsonObject = try JSONSerialization.jsonObject(with: jsData, options: [])
            
            guard let jsonArrayNotes = anyJsonObject as? [[String : Any]] else { return }
            
            notes = []
            
            for item in jsonArrayNotes {
                if let note = Note.parse(json: item) {
                    add(note)
                }
//                if let imageNote = ImageNote.parse(json: item){
//                    add(imageNote)
//                }
            }
        } catch {
        }
        imageNotes = FileNotebook.defaultImageNotes()
    }

    private func getFileNotebookPath() -> URL? {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        var isDir: ObjCBool = false
        let dirUrl = path.appendingPathComponent("notebooks")
        
        if !FileManager.default.fileExists(atPath: dirUrl.path, isDirectory: &isDir), !isDir.boolValue {
            do {
                try FileManager.default.createDirectory(at: dirUrl, withIntermediateDirectories: true, attributes: nil)
            } catch {
                return nil
            }
        }
        
        let fileUrl = dirUrl.appendingPathComponent("Filenotebook")
        
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            if !FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil) {
                return nil
            }
        }
        
        return fileUrl
        
    }
    private static func defaultImageNotes() -> [ImageNote] {
        return [
            ImageNote(name: "Sunrise.png", isDefault: true),
            ImageNote(name: "SunriseOverMountains.png", isDefault: true),
            ImageNote(name: "Sparkler.png", isDefault: true),
            ImageNote(name: "Fireworks.png", isDefault: true),
            ImageNote(name: "Sunset.png", isDefault: true),
            ImageNote(name: "CityscapeAtDusk.png", isDefault: true),
            ImageNote(name: "Cityscape.png", isDefault: true),
            ImageNote(name: "NightWithStars.png", isDefault: true),
            ImageNote(name: "MilkyWay.png", isDefault: true),
            ImageNote(name: "BridgeAtNight.png", isDefault: true),
            ImageNote(name: "Foggy.png", isDefault: true)
        ]
    }

}
