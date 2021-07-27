//
//  HomeViewVC.swift
//  Shapr3D
//
//  Created by Muhammad Imran on 26/07/2021.
//

import UIKit
import MobileCoreServices
class HomeViewVC: UIViewController, UIDocumentPickerDelegate {
    
    @IBOutlet weak var collectionView : UICollectionView!
    
    
    var arrayOfData = [Model]()
    var destURL : URL?
    let textLabel = UILabel()
    let emptyListImage = UIImageView()
    let fileManager = FileManager.default
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        reteriveData()
        
    }
    
    //MARK: - Helper
    func registerNib(){
        collectionView.delegate  = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ConversionCell", bundle: nil), forCellWithReuseIdentifier: "ConversionCell")
    }
    
    func lisHaveNoData() {
        collectionView.isHidden = true
        let image = UIImage(named: "emptyTable")
        emptyListImage.image = image
        textLabel.text = "Upload Files"
        textLabel.textColor = .label
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyListImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(emptyListImage)
        self.view.addSubview(textLabel)
        emptyListImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        emptyListImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        emptyListImage.heightAnchor.constraint(equalToConstant: 200).isActive =  true
        emptyListImage.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        textLabel.topAnchor.constraint(equalTo: emptyListImage.bottomAnchor, constant: 10).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: emptyListImage.centerXAnchor, constant: 0).isActive = true
        
        
    }
    
    func listHaveData() {
        collectionView.isHidden = false
        emptyListImage.removeFromSuperview()
        textLabel.removeFromSuperview()
    }
    
    func reteriveData() {
        CoreDataHelper.shared.retrieveData(completionalHandler: { [self] data in
            arrayOfData  = data
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
    
    
    // MARK: - IBAction
    
    @IBAction  func didTapDocumentPickerButton(sender : UIBarButtonItem) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)], in: .import)
        documentPicker.delegate = self
        self.present(documentPicker, animated: true)
    }
    
    // MARK: - Long Press Gesture Action Sheet
    @objc func longPressActionCell(longPressGesture : UILongPressGestureRecognizer)
    {
        let point = longPressGesture.location(in: self.collectionView)
        let indexPath = self.collectionView?.indexPathForItem(at: point)
        
        if indexPath != nil
        {
            let alertActionCell = UIAlertController(title: "Delete File", message: "Choose an action for the selected File", preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { [self] action in
                CoreDataHelper.shared.deleteData(model: arrayOfData[indexPath!.row], completionalHandler: { isDeleted in
                    if isDeleted{
                        removeFileFromDir(fileName: arrayOfData[indexPath!.row].fileName)
                        arrayOfData.remove(at: indexPath!.row)
                        
                        self.collectionView!.reloadData()
                    }
                    else{
                        print("File Not Delet")
                    }
                })
                
            })
            
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { acion in
                print("Cancel")
            })
            
            alertActionCell.addAction(deleteAction)
            alertActionCell.addAction(cancelAction)
            self.present(alertActionCell, animated: true, completion: nil)
            
        }
    }
    
    
    //MARK: - DocumentPicker Delegate & Helper Funtions
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        for url in urls{
            copyFileToDocumentsFolder(nameForFile: url.lastPathComponent, extForFile: ".shapr" , sourceURL: url)
        }
        
    }
    
    
    func copyFileToDocumentsFolder( nameForFile: String, extForFile: String , sourceURL : URL) {
        
        var fileName = nameForFile
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        //.appendingPathExtension(extForFile)
        
        if  fileAlreadyExist(fileName: nameForFile){
                fileName = "\(nameForFile) (\(CoreDataHelper.shared.resultCount(itemName: fileName)))"
        }
        
        destURL = documentsURL!.appendingPathComponent(fileName)
        do {
            try fileManager.copyItem(at: sourceURL, to: destURL!)
            CoreDataHelper.shared.createData(fileData: Model(isSelected: false, fileName: fileName, size: String(sizeForLocalFilePath(filePath: destURL!.path)), filePath: destURL!.path , progressObj: 0, progressStep: 0, progressStl: 0, iSConvertedObj: false, isConvertedStep: false, isConvertedStl: false, uuid: UUID().uuidString), completionalHandler: { [self] isSave in
                if isSave{
                    reteriveData()
                }
            })
            
            
        } catch {
            print("Unable to copy file")
        }
        
    }
    
    
    
    func sizeForLocalFilePath(filePath:String) -> UInt64 {
        do {
            let fileAttributes = try FileManager().attributesOfFileSystem(forPath: filePath)
            if let fileSize = fileAttributes[FileAttributeKey.systemSize] as? UInt64 {
                return fileSize
            } else {
                print("Failed to get a size attribute from path: \(filePath)")
            }
        } catch {
            print("Failed to get file attributes for local path: \(filePath) with error: \(error)")
        }
        return 0
    }
    
    func removeFileFromDir(fileName:String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let documentDirectoryFileUrl = documentsDirectory.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: documentDirectoryFileUrl.path) {
            do {
                try FileManager.default.removeItem(at: documentDirectoryFileUrl)
            } catch {
                print("Could not delete file: \(error)")
            }
        }
    }
    
    func fileAlreadyExist(fileName : String) -> Bool {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return false}
        let outputUrl = documentsDirectory.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: outputUrl.path) {
            return true
        } else{
            return false
        }
    }
}


//MARK: - CollectionView Delegate & DataSourcse


extension HomeViewVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrayOfData.count > 0{
            listHaveData()
            return arrayOfData.count
        }
        else{
            lisHaveNoData()
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConversionCell", for: indexPath) as! ConversionCell
        cell.expandBtn.tag = indexPath.row
        cell.delegate = self
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressActionCell))
        cell.addGestureRecognizer(longPressGesture)
        cell.setupUI(model: arrayOfData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.height / 6 * 4, height: 260)
    }
    
    
}

extension HomeViewVC : ConversionCellDelegate{
    func convertToObj(tag: Int) {
        
    }
    
    func convertToStep(tag: Int) {
        
    }
    
    func convertToStl(tag: Int) {
        
    }
    
    
    func detailViewExpand(tag: Int) {
        if arrayOfData[tag].isSelected {
            arrayOfData[tag].isSelected = false
        }
        else{
            arrayOfData[tag].isSelected = true
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
