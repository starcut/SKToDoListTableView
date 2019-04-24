//
//  SKToDoListTableViewCell.swift
//  SKToDoListTableView
//
//  Created by 清水 脩輔 on 2019/04/12.
//  Copyright © 2019 清水 脩輔. All rights reserved.
//

import UIKit

// アニメーションの時間
let ANIMATION_DURATION: TimeInterval = 0.2

protocol SKToDoListTableViewCellDelegate {
    // toDoTextLabelの行数や高さを設定する
    func setToDoTextLabelHeight(cell: SKToDoListTableViewCell, labelHeight: CGFloat, linesNumber: Int)
    // 完了・未完了の切り替えを行う
    func switchCompletionStatus(cell: SKToDoListTableViewCell)
    // 全文表示・正暦表示の切り替えを行う
    func switchExpandStatus(cell: SKToDoListTableViewCell)
    // 編集ボタンが押された時のデリゲートメソッド
    func pushedEditButton(row: Int, toDoText: String, priority: ToDoPriority, dealline: String)
}

extension SKToDoListTableViewCellDelegate {
    // toDoTextLabelの行数や高さを設定する
    func setToDoTextLabelHeight(cell: SKToDoListTableViewCell, labelHeight: CGFloat, linesNumber: Int){}
    // 完了・未完了の切り替えを行う
    func switchCompletionStatus(cell: SKToDoListTableViewCell) {}
    // 全文表示・正暦表示の切り替えを行う
    func switchExpandStatus(cell: SKToDoListTableViewCell) {}
    // 編集ボタンが押された時のデリゲートメソッド
    func pushedEditButton(row: Int, toDoText: String, priority: ToDoPriority, dealline: String) {}
}

class SKToDoListTableViewCell: UITableViewCell {
    // ToDOリストの文言
    @IBOutlet private weak var toDoTextLabel: UILabel!
    // 編集ボタン
    @IBOutlet private weak var editButton: UIButton!
    // 全文表示しているかどうかを表す矢印のビュー
    @IBOutlet private weak var arrowImageView: UIImageView!
    // ToDOリストの文言の上マージン
    @IBOutlet private weak var toDoTextLabelTopMargin: NSLayoutConstraint!
    // ToDOリストの文言の下マージン
    @IBOutlet private weak var toDoTextLabelBottomMargin: NSLayoutConstraint!
    // 期日を表示するラベル
    @IBOutlet private weak var deadlineLabel: UILabel!
    // 期日を表示するラベルの高さ
    @IBOutlet private weak var deadlineLabelHeight: NSLayoutConstraint!
    // 期日を表示するラベルの上マージン
    @IBOutlet private weak var deadlineLabelTopMargin: NSLayoutConstraint!
    
    var delegate: SKToDoListTableViewCellDelegate?
    // セルの位置情報
    var indexPath: IndexPath!
    // ToDoの優先度
    var priority: ToDoPriority = .middlePriority
    // 完了のテキストカラー
    private let COMPLETED_TEXT_COLOR: UIColor = .lightGray
    // テキストからラベルの高さを取得する際、少しゆとりをもつための値
    private let LABEL_HEIGHT_FIXED: CGFloat = 2.0
    // アニメーション中など、セルを広げる処理が可能なタイミングかどうか
    private var canExpand: Bool = false
    
    // MARK: Override Method
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Public Method
    
    /**
     * セルに関する設定を行う
     *
     * - Parameters:
     *  - model:        ToDoリストに関するモデル
     *  - indexPath:    セルのテーブルビュー上の位置情報
     */
    func setCellConfigure(model: ToDoListModel, indexPath: IndexPath) {
        self.editButton.setBackgroundImage(UIImage(named: "icon_edit",
                                                   in: Bundle(for: type(of: self)),
                                                   compatibleWith: nil),
                                           for: .normal)
        self.arrowImageView.image = UIImage(named: "icon_arrow",
                                            in: Bundle(for: type(of: self)),
                                            compatibleWith: nil)
        
        self.indexPath = indexPath
        self.priority = model.priority
        self.switchTextStyle(model: model)
        self.canExpand = false
        self.deadlineLabel.text = model.deadline
        
        // セルの高さが未設定（初回）のみ行う
        if model.textHeight == 0.0 {
            self.calcLabelHeight()
        }
        // 矢印の向き
        self.setDirectionArrowIcon(isExpanded: model.isExpanded)
        self.registerGesture(linesNumber: model.linesNumber)
    }
    
    /**
     * セルの全文表示・一行表示を切り替えのアニメーションの処理
     */
    func switchExpandCell(isExpanded: Bool) {
        UIView.animate(withDuration: ANIMATION_DURATION) {
            self.setDirectionArrowIcon(isExpanded: isExpanded)
        }
    }
    
    /**
     * セルの全文表示・一行表示を切り替えのアニメーションを行った後の処理
     */
    func updateCompletion() {
        self.canExpand = true
    }
    
    // MARK: Private Method
    
    /**
     * 矢印アイコンの向きを設定する
     */
    private func setDirectionArrowIcon(isExpanded: Bool) {
        if isExpanded {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/1000.0*999)
        } else {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: 0.0)
        }
    }
    
    /**
     * toDoTextLabelの一行あたりの高さ、全体の行数、全体の高さを取得する
     */
    private func calcLabelHeight() {
        // 正しい幅を取得するためにレイアウト更新
        self.layoutIfNeeded()
        let labelLineHeight: CGFloat = self.toDoTextLabel.frame.height
        
        let bounds: CGSize = CGSize(width: self.toDoTextLabel.frame.size.width,
                                    height: .greatestFiniteMagnitude)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let rect: CGRect = self.toDoTextLabel.attributedText?.boundingRect(with: bounds,
                                                                           options: options,
                                                                           context: nil) ?? CGRect.zero
        
        var fixedHeight: CGFloat = self.toDoTextLabelTopMargin.constant
        fixedHeight += self.toDoTextLabelBottomMargin.constant
        fixedHeight += self.deadlineLabelTopMargin.constant
        fixedHeight += self.deadlineLabelHeight.constant
        fixedHeight += LABEL_HEIGHT_FIXED
        
        self.delegate?.setToDoTextLabelHeight(cell: self,
                                              labelHeight: ceil(rect.size.height) + fixedHeight,
                                              linesNumber: Int(ceil(rect.size.height) / labelLineHeight) )
    }
    
    /**
     * ToDoの優先度、完了しているかどうかでテキストのスタイルを変更する
     *
     * - Parameters:
     *   - model: ToDoリストに関するモデル
     */
    private func switchTextStyle(model: ToDoListModel) {
        var stringAttributes : [NSAttributedString.Key : Any] = Dictionary()
        
        if model.isCompleted {
            stringAttributes = [
                .foregroundColor: COMPLETED_TEXT_COLOR,
                .font: UIFont.systemFont(ofSize: self.toDoTextLabel.font.pointSize,
                                         weight: .light),
                .strikethroughStyle: 2
            ]
            let attributeString: NSAttributedString = NSAttributedString(string: model.text,
                                                                         attributes: stringAttributes)
            self.toDoTextLabel.attributedText = attributeString
        } else {
            
            
            // 優先度によってフォントを変更
            switch model.priority {
            case .lowPriority:
                stringAttributes = [
                    .foregroundColor: UIColor.blue,
                    .font: UIFont.systemFont(ofSize: self.toDoTextLabel.font.pointSize,
                                             weight: .light)
                ]
                break
                
            case .middlePriority:
                stringAttributes = [
                    .foregroundColor: UIColor.black,
                    .font: UIFont.systemFont(ofSize: self.toDoTextLabel.font.pointSize,
                                             weight: .regular)
                ]
                break
                
            case .highPriority:
                stringAttributes = [
                    .foregroundColor: UIColor.orange,
                    .font: UIFont.systemFont(ofSize: self.toDoTextLabel.font.pointSize,
                                             weight: .regular)
                ]
                break
                
            case .emergencyPriority:
                stringAttributes = [
                    .foregroundColor: UIColor.red,
                    .font: UIFont.systemFont(ofSize: self.toDoTextLabel.font.pointSize,
                                             weight: .bold)
                ]
                break
            }
            self.toDoTextLabel.attributedText = NSAttributedString(string: model.text,
                                                                   attributes: stringAttributes)
        }
    }
    
    /**
     * セルのタッチイベントに関する登録を行う
     */
    private func registerGesture(linesNumber: Int) {
        if (self.gestureRecognizers?.count ?? 0) > 0 {
            for tapGesture in self.gestureRecognizers! {
                self.removeGestureRecognizer(tapGesture)
            }
        }
        
        // 文言が二行以上の場合、タップイベント追加
        if linesNumber > 1 {
            self.canExpand = true
            
            // タップをした時の処理
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                            action: #selector(updateExpandStatus))
            self.addGestureRecognizer(tapGesture)
            self.arrowImageView.isHidden = false
        } else {
            self.arrowImageView.isHidden = true
        }
        
        // 右スワイプを行った時の処理
        let rightSwipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self,
                                                                                   action: #selector(finishToDo))
        rightSwipeGesture.direction = .right
        self.addGestureRecognizer(rightSwipeGesture)
    }
    
    // MARK: IBAction
    
    /**
     * 編集ボタンが押された時の動作
     */
    @IBAction func pushedEditButton() {
        self.delegate?.pushedEditButton(row: self.indexPath.row,
                                        toDoText: self.toDoTextLabel.text!,
                                        priority: self.priority,
                                        dealline: self.deadlineLabel.text!)
    }
    
    // MARK: UISwipeGestureRecognizer, UITapGestureRecognizer
    
    /**
     * ToDoの完了・未完了を切り替える
     */
    @objc private func finishToDo() {
        // 完了・未完了を切り替える
        self.delegate?.switchCompletionStatus(cell: self)
    }
    
    /**
     * ToDoリストの一行表示・全体表示を切り替える
     */
    @objc private func updateExpandStatus() {
        // アニメーション中はタップできない
        if !self.canExpand {
            return
        }
        
        self.canExpand = false
        self.delegate?.switchExpandStatus(cell: self)
    }
}
