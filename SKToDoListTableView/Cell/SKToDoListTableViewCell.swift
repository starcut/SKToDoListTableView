//
//  SKToDoListTableViewCell.swift
//  SKToDoListTableView
//
//  Created by 清水 脩輔 on 2019/04/12.
//  Copyright © 2019 清水 脩輔. All rights reserved.
//

import UIKit

protocol SKToDoListTableViewCellDelegate {
    // 完了・未完了の切り替えを行う
    func switchCompletionStatus(cell: SKToDoListTableViewCell)
    // 全文表示・正暦表示の切り替えを行う
    func switchExpandStatus(cell: SKToDoListTableViewCell, height: CGFloat)
}

extension SKToDoListTableViewCellDelegate {
    // 完了・未完了の切り替えを行う
    func switchCompletionStatus(cell: SKToDoListTableViewCell) {}
    // 全文表示・正暦表示の切り替えを行う
    func switchExpandStatus(cell: SKToDoListTableViewCell, height: CGFloat) {}
}

class SKToDoListTableViewCell: UITableViewCell {
    // ToDOリストの文言
    @IBOutlet weak var toDoTextLabel: UILabel!
    // 全文表示しているかどうかを表す矢印のビュー
    @IBOutlet weak var arrowImageView: UIImageView!
    // ToDOリストの文言の上マージン
    @IBOutlet weak var toDoTextLabelTopMargin: NSLayoutConstraint!
    // ToDOリストの文言の下マージン
    @IBOutlet weak var toDoTextLabelBottomMargin: NSLayoutConstraint!
    var delegate: SKToDoListTableViewCellDelegate?
    // セルの位置情報
    var indexPath: IndexPath!
    // 未完了のテキストカラー
    private let DEFAULT_TEXT_COLOR: UIColor = .red
    // 完了のテキストカラー
    private let COMPLETED_TEXT_COLOR: UIColor = .lightGray
    // アニメーションの時間
    private let ANIMATION_DURATION: TimeInterval = 0.2
    // アニメーション中など、セルを広げる処理が可能なタイミングかどうか
    private var canExpand: Bool = false
    // セルを広げているかどうか
    private var isExpanded: Bool = false
    
    // MARK: 初期化処理
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    @objc func updateExpandStatus() {
        if !canExpand {
            return
        }
        // アニメーション中はタップできないようにする
        self.canExpand = false
        
        var cellHeight: CGFloat = 0.0
        if !self.isExpanded {
            let bounds: CGSize = CGSize(width: self.toDoTextLabel.frame.width, height: .greatestFiniteMagnitude)
            let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
            let rect: CGRect = self.toDoTextLabel.attributedText?.boundingRect(with: bounds, options: options, context: nil) ?? CGRect.zero
            let labelHeight: CGFloat = rect.size.height
            
            let marginHeight: CGFloat = self.toDoTextLabelTopMargin.constant + self.toDoTextLabelBottomMargin.constant
            cellHeight = labelHeight + marginHeight
        }
        self.delegate?.switchExpandStatus(cell: self, height: ceil(cellHeight))
    }
    
    func switchExpandCell() {
        if !self.isExpanded {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: 0.0)
        } else {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/1000.0*999)
        }
    }
    
    func updateCompletion() {
        if !self.isExpanded {
            self.toDoTextLabel.numberOfLines = 0
        } else {
            self.toDoTextLabel.numberOfLines = 1
        }
        self.isExpanded = !self.isExpanded
        self.canExpand = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /**
     * セルに関する設定を行う
     *
     * - Parameters:
     *  - model:        ToDoリストに関するモデル
     *  - indexPath:    セルのテーブルビュー上の位置情報
     */
    func setCellConfigure(model: ToDoListModel, indexPath: IndexPath) {
        self.toDoTextLabel.text = model.text
        self.indexPath = indexPath
        self.switchTextStyle(model: model)
        self.canExpand = true
        self.registerGesture()
        let textArray: [Substring] = model.text.split(separator: "\n")
        if textArray.count > 1 {
            self.isExpanded = false
        } else {
            self.isExpanded = true
        }
    }
    
    private func registerGesture() {
        if (self.gestureRecognizers?.count ?? 0) > 0 {
            for tapGesture in self.gestureRecognizers! {
                self.removeGestureRecognizer(tapGesture)
            }
        }
        
        let splitedText: [Substring]! = self.toDoTextLabel.text?.split(separator: "\n")
        // TODO: ラベルの高さで行数を認識する
        // 文言が一行で済む場合はタップイベントを登録しない
        if splitedText.count <= 1 {
            self.arrowImageView.isHidden = true
        } else {
            // タップをした時の処理
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(updateExpandStatus))
            self.addGestureRecognizer(tapGesture)
            self.arrowImageView.isHidden = false
        }
        // 右スワイプを行った時の処理
        let rightSwipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(finishToDo))
        rightSwipeGesture.direction = .right
        self.addGestureRecognizer(rightSwipeGesture)
    }
    
    // MARK: UISwipeGestureRecognizer
    
    /**
     * ToDoの完了・未完了を切り替える
     */
    @objc private func finishToDo() {
        // 完了・未完了を切り替える
        self.delegate?.switchCompletionStatus(cell: self)
    }
    
    // MARK: Private Method
    
    /**
     * ToDoの優先度、完了しているかどうかでテキストのスタイルを変更する
     *
     * - Parameters:
     *   - model: ToDoリストに関するモデル
     */
    private func switchTextStyle(model: ToDoListModel) {
        if model.isCompleted {
            let stringAttributes : [NSAttributedString.Key : Any] = [
                .foregroundColor: COMPLETED_TEXT_COLOR,
                .strikethroughStyle: 2
            ]
            let attributeString: NSAttributedString = NSAttributedString(string: self.toDoTextLabel.text!, attributes: stringAttributes)
            self.toDoTextLabel.attributedText = attributeString
            self.toDoTextLabel.textColor = COMPLETED_TEXT_COLOR
        } else {
            var stringAttributes : [NSAttributedString.Key : Any] = Dictionary.init()
            
            // 優先度によってフォントを変更
            switch model.priority {
            case .lowPriority:
                stringAttributes = [
                    .foregroundColor: UIColor.blue,
                    .font: UIFont.systemFont(ofSize: 17.0, weight: .light)
                ]
            break
                
            case .middlePriority:
                stringAttributes = [
                    .foregroundColor: UIColor.black,
                    .font: UIFont.systemFont(ofSize: 17.0, weight: .regular)
                ]
            break
                
            case .highPriority:
                stringAttributes = [
                    .foregroundColor: UIColor.orange,
                    .font: UIFont.systemFont(ofSize: 17.0, weight: .regular)
                ]
            break
                
            case .emergencyPriority:
                stringAttributes = [
                    .foregroundColor: UIColor.red,
                    .font: UIFont.systemFont(ofSize: 17.0, weight: .bold)
                ]
            break
            }
            self.toDoTextLabel.attributedText = NSAttributedString(string: self.toDoTextLabel.text!, attributes: stringAttributes)
        }
    }
}
