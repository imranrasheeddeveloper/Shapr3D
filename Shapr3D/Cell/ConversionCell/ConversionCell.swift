//
//  ConversionCell.swift
//  Shapr3D
//
//  Created by Muhammad Imran on 26/07/2021.
//

import UIKit

protocol ConversionCellDelegate {
    func detailViewExpand(tag : Int)
    func convertToObj(tag : Int)
    func convertToStep(tag : Int)
    func convertToStl(tag : Int)
}

class ConversionCell: UICollectionViewCell {
    @IBOutlet weak var stepConvertButton: UIButton!
    @IBOutlet weak var objLbl: UILabel!
    @IBOutlet weak var stlConvertButton: UIButton!
    @IBOutlet weak var objConvertButton: UIButton!
    @IBOutlet weak var detailView : UIView!
    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var fileSize: UILabel!
    @IBOutlet weak var expandBtn : UIButton!
    @IBOutlet weak var stlProgressPercent: UILabel!
    @IBOutlet weak var stepProgressPercent: UILabel!
    @IBOutlet weak var objProgressPercent: UILabel!
    @IBOutlet weak var stlLbl: UILabel!
    @IBOutlet weak var steplLbl: UILabel!
    @IBOutlet weak var objProgressBar: UIProgressView!
    @IBOutlet weak var stepProgressBar: UIProgressView!
    @IBOutlet weak var stlProgressBar: UIProgressView!
    var delegate : ConversionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        detailView.isHidden = true
    }
    
    override var isHighlighted: Bool{
        didSet{
            if isHighlighted{
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                    self.transform = self.transform.scaledBy(x: 0.75, y: 0.75)
                }, completion: nil)
            }else{
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                }, completion: nil)
            }
        }
    }
    
    
    func setupUI(model : Model) {
        //Hide or show the Labels
    
        objLbl.isHidden = !model.iSConvertedObj
        steplLbl.isHidden = !model.isConvertedStep
        stlLbl.isHidden = !model.isConvertedStl
        
        fileName.text = model.fileName
        fileSize.text = "\(model.size) Size"
        
        stepProgressPercent.text = "\(String(model.progressStep))%"
        stlProgressPercent.text = "\(String(model.progressStl))%"
        objProgressPercent.text = "\(String(model.progressObj))%"
        
        objProgressBar.setProgress(Float(model.progressObj), animated: true)
        stepProgressBar.setProgress(Float(model.progressStep), animated: true)
        stlProgressBar.setProgress(Float(model.progressStl), animated: true)
        
        if model.isSelected == false{
            detailView.isHidden = true
        }else{
            detailView.isHidden = false
        }
        
    }
    
    @IBAction func didTapConvertStl(_ sender: UIButton) {
        delegate?.convertToStl(tag: sender.tag)
    }
    @IBAction func didTapConvertSep(_ sender: UIButton) {
        delegate?.convertToStep(tag: sender.tag)
    }
    @IBAction func didTapConvertObj(_ sender: UIButton) {
        delegate?.convertToObj(tag: sender.tag)
    }
}
extension ConversionCell {
    @IBAction func didTapExpand(sender : UIButton){
        delegate?.detailViewExpand(tag: sender.tag)
    }
}
