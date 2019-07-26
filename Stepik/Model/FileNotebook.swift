import Foundation

public class FileNotebook {
    private(set) var notes: [Note]
    private let fileManager: FileManager
    private let filePath: String
    
    public func add(_ note: Note){
        guard !notes.contains(where: {return $0.uid == note.uid })else{
            return
        }
        notes.append(note)
    }
    
    public func remove(with uid: String){
        if let index = notes.firstIndex(where: {return $0.uid == uid }){
            notes.remove(at: index)
        }
    }
    
    public func saveToFile(){
        var jsonArray: [[String: Any]] = []
        
        for note in notes{
            jsonArray.append(note.json)
        }
        
        guard let jsonData = encodeData(json: jsonArray) else {
            return
        }
        write(data: jsonData)
    }
    
    public func loadFromFile(){
        if FileManager.default.fileExists(atPath: filePath){
            guard let jsonArray = read(filePath: filePath) else{
                return
            }
            
            for object in jsonArray{
                if let note = Note.parse(json: object){
                    self.add(note)
                }
            }
        }else{
            notes = FileNotebook.defaultNotes()
        }
    }
    
    private static func defaultNotes() -> [Note] {
        return [
            Note(title: "Заголовок заметки", content: "Текст заметки, Текст заметки, Текст заметки, Текст заметки, Текст заметки", priority: .base, color: .red, expiredDate: nil),
            Note(title: "Короткая заметка", content: "Текст", priority: .base, color: .green, expiredDate: nil),
            Note(title: "Длинная заметка", content: "Длинный текст заметки, Длинный текст заметки, Длинный текст заметки, Длинный текст заметки, Длинный текст заметки, Длинный текст заметки, Длинный текст заметки, Длинный текст заметки, Длинный текст заметки, Длинный текст заметки, Длинный текст заметки, Длинный текст заметки, Длинный текст заметки, Длинный текст заметки, Длинный текст заметки, Длинный текст заметки, Длинный текст заметки, Длинный текст заметки, Длинный текст заметки", priority: .base, color: .blue, expiredDate: nil),
            Note(title: "3аголовок заметки - 2", content: "Текст заметки, Текст заметки, Текст заметки, Текст заметки, Текст заметки", priority: .base, color: .yellow, expiredDate: nil),
            Note(title: "Короткая заметка", content: "Не забыть выключить утюг", priority: .base, color: .cyan, expiredDate: nil)
        ]
    }
    
    private func write(data: Data){
        fileManager.createFile(atPath: filePath, contents: data, attributes: nil)
    }
    
    private func read(filePath: String) -> [[String: Any]]? {
        guard fileManager.fileExists(atPath: filePath),
            let jsonData = fileManager.contents(atPath: filePath) else {
                return nil
        }
        return decodeData(from: jsonData)
        
    }
    
    private func encodeData(json: Any) -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: json, options: [])
        } catch let error as NSError {
            print("error \(error.userInfo)")
            return nil
        }
    }
    
    private func decodeData(from data: Data) -> [[String: Any]]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
        } catch let error as NSError {
            print("error \(error.userInfo)")
            return nil
        }
    }
    
    
    public init() {
        notes = []
        fileManager = FileManager.default
        let URL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        let appFolder = URL!.appendingPathComponent("NOTES")
        filePath = appFolder.appendingPathComponent("notes.json").absoluteString
        print(filePath)
    }
}
