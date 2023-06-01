//
//  ElegantEmojiPicker.swift
//  Demo
//
//  Created by Grant Oganyan on 3/10/23.
//

import Foundation
import UIKit

/// Present this view controller when you want to offer users emoji selection. Conform to its delegate ElegantEmojiPickerDelegate and pass it to the view controller to interact with it and receive user's selection. 
open class ElegantEmojiPicker: UIViewController {
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public weak var delegate: ElegantEmojiPickerDelegate?
    public let config: ElegantConfiguration
    public let localization: ElegantLocalization
    
    let padding = 16.0
    let topElementHeight = 40.0
    
    let backgroundBlur = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    
    var searchFieldBackground: UIVisualEffectView?
    var searchField: UITextField?
    var clearButton: UIButton?
    var randomButton: UIButton?
    var resetButton: UIButton?
    var closeButton: UIButton?
    
    let fadeContainer = UIView()
    let collectionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 40.0, height: 40.0)
        return layout
    }()
    var collectionView: UICollectionView!
    
    var toolbar: SectionsToolbar?
    var toolbarBottomConstraint: NSLayoutConstraint?
    
    var skinToneSelector: SkinToneSelector?
    var emojiPreview: EmojiPreview?
    public var previewingEmoji: Emoji?
    
    var emojiSections = [EmojiSection]()
    var searchResults: [Emoji]?
    
    private var prevFocusedSection: Int = 0
    var focusedSection: Int = 0
    
    var isSearching: Bool = false
    var overridingFocusedSection: Bool = false
    
    /// Initialize and present this view controller to offer emoji selection to users.
    /// - Parameters:
    ///   - delegate: provide a delegate to interact with the picker
    ///   - configuration: provide a configuration to change UI and behavior
    ///   - localization: provide a localization to change texts on all labels
    ///   - sourceView: provide a source view for a popover presentation style.
    ///   - sourceNavigationBarButton: provide a source navigation bar button for a popover presentation style.
    public init (delegate: ElegantEmojiPickerDelegate? = nil, configuration: ElegantConfiguration = ElegantConfiguration(), localization: ElegantLocalization = ElegantLocalization(), sourceView: UIView? = nil, sourceNavigationBarButton: UIBarButtonItem? = nil) {
        self.delegate = delegate
        self.config = configuration
        self.localization = localization
        super.init(nibName: nil, bundle: nil)
        
        self.emojiSections = self.delegate?.emojiPicker(self, loadEmojiSections: config, localization) ?? ElegantEmojiPicker.getDefaultEmojiSections(config: config, localization: localization)
        
        if let sourceView = sourceView, !AppConfiguration.isIPhone, AppConfiguration.windowFrame.width > 500 {
            self.modalPresentationStyle = .popover
            self.popoverPresentationController?.sourceView = sourceView
        } else if let sourceNavigationBarButton = sourceNavigationBarButton, !AppConfiguration.isIPhone, AppConfiguration.windowFrame.width > 500 {
            self.modalPresentationStyle = .popover
            self.popoverPresentationController?.barButtonItem = sourceNavigationBarButton
        } else {
            self.modalPresentationStyle = .formSheet
            if #available(iOS 15.0, *) {
                self.sheetPresentationController?.prefersGrabberVisible = true
                self.sheetPresentationController?.detents = [.medium(), .large()]
            }
        }
        
        self.presentationController?.delegate = self
        
        self.view.addSubview(backgroundBlur, anchors: LayoutAnchor.fullFrame)
        
        if config.showSearch {
            searchFieldBackground = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
            searchFieldBackground!.layer.cornerRadius = 8
            searchFieldBackground!.clipsToBounds = true
            searchFieldBackground!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TappedSearchBackground)))
            self.view.addSubview(searchFieldBackground!, anchors: [.safeAreaLeading(padding), .safeAreaTop(padding*1.5), .height(topElementHeight)])
            
            let spacing = 10.0
            
            clearButton = UIButton()
            clearButton!.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            clearButton!.tintColor = .systemGray
            clearButton!.alpha = 0
            clearButton!.contentMode = .scaleAspectFit
            clearButton!.setContentHuggingPriority(.required, for: .horizontal)
            clearButton!.setContentCompressionResistancePriority(.required, for: .horizontal)
            clearButton!.addTarget(self, action: #selector(ClearButtonTap), for: .touchUpInside)
            searchFieldBackground?.contentView.addSubview(clearButton!, anchors: [.trailing(spacing), .top(spacing), .bottom(spacing)])
            
            searchField = UITextField()
            searchField!.placeholder = localization.searchFieldPlaceholder
            searchField!.delegate = self
            searchField!.addTarget(self, action: #selector(searchFieldChanged), for: .editingChanged)
            searchFieldBackground!.contentView.addSubview(searchField!, anchors: [.leading(spacing), .top(spacing), .bottom(spacing), .trailingToLeading(clearButton!, spacing)])
        }
        
        if config.showRandom {
            randomButton = UIButton()
            randomButton!.setTitle(localization.randomButtonTitle, for: .normal)
            randomButton!.setTitleColor(.label, for: .normal)
            randomButton!.setTitleColor(.systemGray, for: .highlighted)
            randomButton!.addTarget(self, action: #selector(TappedRandom), for: .touchUpInside)
            randomButton!.contentHorizontalAlignment = .trailing
            randomButton!.setContentHuggingPriority(.required, for: .horizontal)
            randomButton!.setContentCompressionResistancePriority(.required, for: .horizontal)
            self.view.addSubview(randomButton!, anchors: [.safeAreaTop(padding*1.5), .height(topElementHeight)])
            randomButton?.leadingAnchor.constraint(equalTo: searchFieldBackground?.trailingAnchor ?? self.view.safeAreaLayoutGuide.leadingAnchor, constant: padding).isActive = true
        }
        
        if config.showReset {
            resetButton = UIButton()
            resetButton!.setImage(UIImage(systemName: "clear"), for: .normal)
            resetButton!.tintColor = .systemRed
            resetButton!.addTarget(self, action: #selector(TappedReset), for: .touchUpInside)
            resetButton?.contentHorizontalAlignment = .trailing
            resetButton?.setContentHuggingPriority(.required, for: .horizontal)
            resetButton?.setContentCompressionResistancePriority(.required, for: .horizontal)
            self.view.addSubview(resetButton!, anchors: [.safeAreaTop(padding*1.5), .height(topElementHeight)])
            resetButton?.leadingAnchor.constraint(equalTo: randomButton?.trailingAnchor ?? searchFieldBackground?.trailingAnchor ?? self.view.safeAreaLayoutGuide.leadingAnchor, constant: padding).isActive = true
        }
        
        if config.showClose {
            closeButton = UIButton()
            closeButton!.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            closeButton!.addTarget(self, action: #selector(TappedClose), for: .touchUpInside)
            closeButton!.setContentHuggingPriority(.required, for: .horizontal)
            closeButton!.contentHorizontalAlignment = .trailing
            closeButton!.setContentCompressionResistancePriority(.required, for: .horizontal)
            self.view.addSubview(closeButton!, anchors: [.safeAreaTop(padding*1.5), .height(topElementHeight)])
            closeButton?.leadingAnchor.constraint(equalTo: resetButton?.trailingAnchor ?? randomButton?.trailingAnchor ?? searchFieldBackground?.trailingAnchor ?? self.view.safeAreaLayoutGuide.leadingAnchor, constant: padding).isActive = true
        }
        
        if let rightMostItem = closeButton ?? resetButton ?? randomButton ?? searchFieldBackground {
            rightMostItem.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -padding).isActive = true
        }
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.05)
        fadeContainer.layer.mask = gradient
        self.view.addSubview(fadeContainer, anchors: [.safeAreaLeading(0), .safeAreaTrailing(0), .bottom(0)])
        fadeContainer.topAnchor.constraint(equalTo: closeButton?.bottomAnchor ?? resetButton?.bottomAnchor ?? randomButton?.bottomAnchor ?? searchFieldBackground?.bottomAnchor ?? self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset.bottom = 50 + padding // Compensating for the toolbar
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView!.register(EmojiCell.self, forCellWithReuseIdentifier: "EmojiCell")
        collectionView!.register(CollectionViewSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        fadeContainer.addSubview(collectionView, anchors: LayoutAnchor.fullFrame)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(LongPress))
        longPress.minimumPressDuration = 0.3
        longPress.delegate = self
        collectionView.addGestureRecognizer(longPress)
        
        if config.showToolbar && emojiSections.count > 1 { AddToolbar() }
    }
    
    func AddToolbar () {
        toolbar = SectionsToolbar(sections: emojiSections, emojiPicker: self)
        self.view.addSubview(toolbar!, anchors: [.centerX(0)])
        
        toolbar!.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: padding).isActive = true
        toolbar!.trailingAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -padding).isActive = true
        
        toolbarBottomConstraint = toolbar!.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        toolbarBottomConstraint?.isActive = true
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionLayout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: 50)
        fadeContainer.layer.mask?.frame = fadeContainer.bounds
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.view.backgroundColor = UIScreen.main.traitCollection.userInterfaceStyle == .light ? .black.withAlphaComponent(0.1) : .clear
    }
    
    @objc func TappedClose () {
        self.dismiss(animated: true)
    }
    
    @objc func TappedRandom () {
        let randomEmoji = emojiSections.randomElement()?.emojis.randomElement()
        didSelectEmoji(randomEmoji)
    }
    
    @objc func TappedReset () {
        didSelectEmoji(nil)
    }
    
    func didSelectEmoji (_ emoji: Emoji?) {
        delegate?.emojiPicker(self, didSelectEmoji: emoji)
        if delegate?.emojiPickerShouldDismissAfterSelection(self) ?? true { self.dismiss(animated: true) }
    }
}

// MARK: Built-in toolbar

extension ElegantEmojiPicker {
    func didSelectSection(_ index: Int) {
        collectionView.scrollToItem(at: IndexPath(row: 0, section: index), at: .centeredVertically, animated: true)
        
        overridingFocusedSection = true
        self.focusedSection = index
        self.toolbar?.UpdateCorrectSelection(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.overridingFocusedSection = false
        }
    }
    
    func HideBuiltInToolbar () {
        toolbarBottomConstraint?.constant = 50
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4) {
            self.toolbar?.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func ShowBuiltInToolbar () {
        toolbarBottomConstraint?.constant = -padding
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4) {
            self.toolbar?.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: Search

extension ElegantEmojiPicker: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func searchFieldChanged (_ textField: UITextField) {
        let count = textField.text!.count
        let searchTerm = textField.text!
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            
            if count == 0 {
                self.searchResults = nil
            } else {
                self.searchResults = self.delegate?.emojiPicker(self, searchResultFor: searchTerm, fromAvailable: self.emojiSections) ?? ElegantEmojiPicker.getSearchResults(searchTerm, fromAvailable: self.emojiSections)
            }
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
                self.collectionView.setContentOffset(.zero, animated: false)
            }
        }
        
        if !isSearching && count > 0 {
            isSearching = true
            clearButton?.alpha = 0.5 // Doing this to keep translucency
            delegate?.emojiPickerDidStartSearching(self)
            HideBuiltInToolbar()
        }
        else if isSearching && count == 0 {
            isSearching = false
            clearButton?.alpha = 0
            delegate?.emojiPickerDidEndSearching(self)
            ShowBuiltInToolbar()
        }
    }
    
    @objc func ClearButtonTap () {
        if let searchField = searchField {
            searchField.text = ""
            searchFieldChanged(searchField)
        }
    }
    
    @objc func TappedSearchBackground () {
        searchField?.becomeFirstResponder()
    }
}

//MARK: Collection view

extension ElegantEmojiPicker: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! CollectionViewSectionHeader
        
        let categoryTitle = emojiSections[indexPath.section].title
        sectionHeader.label.text = searchResults == nil ? categoryTitle : searchResults!.count == 0 ? localization.searchResultsEmptyTitle : localization.searchResultsTitle
        return sectionHeader
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searchResults == nil ? emojiSections.count : 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults?.count ?? emojiSections[section].emojis.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as! EmojiCell
        
        var emoji: Emoji? = nil
        if searchResults != nil && searchResults!.indices.contains(indexPath.row) { emoji = searchResults![indexPath.row] }
        else if emojiSections.indices.contains(indexPath.section) {
            if emojiSections[indexPath.section].emojis.indices.contains(indexPath.row) {
                emoji = emojiSections[indexPath.section].emojis[indexPath.row]
            }
        }
        if emoji != nil { cell.Setup(emoji: emoji!, self) }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selection = searchResults?[indexPath.row] ?? emojiSections[indexPath.section].emojis[indexPath.row]
        didSelectEmoji(selection)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 10 { searchField?.resignFirstResponder() }
        
        DetectCurrentSection()
        HideSkinToneSelector()
    }
}

//MARK: Long press preview

extension ElegantEmojiPicker: UIGestureRecognizerDelegate {
    
    @objc func LongPress (_ sender: UILongPressGestureRecognizer) {
        if !config.supportsPreview { return }
        
        if sender.state == .ended {
            HideEmojiPreview()
            return
        }
        
        let location = sender.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: location), let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell, !(sender.state == .began && cell.emoji.supportsSkinTones && config.supportsSkinTones) else  {  return }
                
        if sender.state == .began {
            ShowEmojiPreview(emoji: cell.emoji)
        } else if sender.state == .changed {
            UpdateEmojiPreview(newEmoji: cell.emoji)
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func ShowEmojiPreview (emoji: Emoji) {
        previewingEmoji = emoji
        emojiPreview = EmojiPreview(emoji: emoji)
        self.present(emojiPreview!, animated: false)
        
        self.delegate?.emojiPicker(self, didStartPreview: emoji)
    }
    
    func UpdateEmojiPreview (newEmoji: Emoji) {
        guard let previewingEmoji = previewingEmoji else { return }
        if previewingEmoji == newEmoji { return }
        
        self.delegate?.emojiPicker(self, didChangePreview: newEmoji, from: previewingEmoji)
        
        emojiPreview?.Update(newEmoji: newEmoji)
        self.previewingEmoji = newEmoji
    }
    
    func HideEmojiPreview () {
        guard let previewingEmoji = previewingEmoji else { return }
        
        self.delegate?.emojiPicker(self, didEndPreview: previewingEmoji)
        
        emojiPreview?.Dismiss()
        emojiPreview = nil
        self.previewingEmoji = nil
    }
}

// MARK: Skin tones

extension ElegantEmojiPicker {
    
    func ShowSkinToneSelector (_ parentCell: EmojiCell) {
        let emoji = parentCell.emoji.duplicate(nil)
        
        skinToneSelector?.removeFromSuperview()
        skinToneSelector = SkinToneSelector(emoji, self, fontSize: parentCell.label.font.pointSize)
        
        collectionView.addSubview(skinToneSelector!, anchors: [.bottomToTop(parentCell, 0)])
        
        let leading = skinToneSelector?.leadingAnchor.constraint(equalTo: parentCell.leadingAnchor)
        leading?.priority = .defaultHigh
        leading?.isActive = true
        
        skinToneSelector?.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: padding).isActive = true
        skinToneSelector?.trailingAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -padding).isActive = true
    }
    
    func HideSkinToneSelector () {
        skinToneSelector?.Disappear() {
            self.skinToneSelector?.removeFromSuperview()
            self.skinToneSelector = nil
        }
    }
    
    func PersistSkinTone (originalEmoji: Emoji, skinTone: EmojiSkinTone?) {
        if !config.persistSkinTones { return }
        
        ElegantEmojiPicker.persistedSkinTones[originalEmoji.description] = skinTone?.rawValue ?? (config.defaultSkinTone == nil ? nil : "")
    }
    
    public func CleanPersistedSkinTones () {
        ElegantEmojiPicker.persistedSkinTones = [:]
    }
}

// MARK: Misc

extension ElegantEmojiPicker {
    
    func DetectCurrentSection () {
        if overridingFocusedSection { return }
        
        let visibleIndexPaths = self.collectionView.indexPathsForVisibleItems
        DispatchQueue.global(qos: .userInitiated).async {
            var sectionCounts = [Int: Int]()
            
            for indexPath in visibleIndexPaths {
                let section = indexPath.section
                sectionCounts[section] = (sectionCounts[section] ?? 0) + 1
            }

            let mostVisibleSection = sectionCounts.max(by: { $0.1 < $1.1 })?.key ?? 0
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                self.focusedSection = mostVisibleSection
                if self.prevFocusedSection != self.focusedSection {
                    self.delegate?.emojiPicker(self, focusedSectionChanged: self.focusedSection, from: self.prevFocusedSection)
                    self.toolbar?.UpdateCorrectSelection()
                }
                self.prevFocusedSection = self.focusedSection
            }
        }
    }
}

extension ElegantEmojiPicker: UIAdaptivePresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // Do not adapt presentation style. We set the presentation style manually in our init(). I know better than Apple.
    }
}


//MARK: Static methods

extension ElegantEmojiPicker {
    
    /// Persists skin tone for a specified emoji.
    /// - Parameters:
    ///   - originalEmoji: Standard yellow emoji for which to persist a skin tone.
    ///   - skinTone: Skin tone to save. Pass nil to remove saved skin tone.
    static public func PersistSkinTone (originalEmoji: Emoji, skinTone: EmojiSkinTone?) {
        ElegantEmojiPicker.persistedSkinTones[originalEmoji.description] = skinTone?.rawValue
    }
    
    /// Delete all persisted emoji skin tones.
    static public func CleanPersistedSkinTones () {
        ElegantEmojiPicker.persistedSkinTones = [:]
    }
    
    /// Dictionary containing all emojis with persisted skin tones. [Emoji : Skin tone]
    static public var persistedSkinTones: [String:String] {
        get { return UserDefaults.standard.object(forKey: "Finalet_Elegant_Emoji_Picker_Skin_Tones_Key") as? [String:String] ?? [:] }
        set { UserDefaults.standard.set(newValue, forKey: "Finalet_Elegant_Emoji_Picker_Skin_Tones_Key") }
    }
    
    /// Returns an array of all available emojis. Use this method to retrieve emojis for your own collection.
    /// - Returns: Array of all emojis.
    static public func getAllEmoji () -> [Emoji] {
        let emojiData = (try? Data(contentsOf: Bundle.module.url(forResource: "Emoji Unicode 15.0", withExtension: "json")!))!
        return try! JSONDecoder().decode([Emoji].self, from: emojiData)
    }
    
    /// Returns an array of all available emojis categorized by section.
    /// - Parameters:
    ///   - config: Config used to setup the emoji picker.
    ///   - localization: Localization used to setup the emoji picker.
    /// - Returns: Array of default sections [EmojiSection] containing all available emojis.
    static public func getDefaultEmojiSections(config: ElegantConfiguration = ElegantConfiguration(), localization: ElegantLocalization = ElegantLocalization()) -> [EmojiSection]  {
        var emojis = getAllEmoji()
        
        let persistedSkinTones = ElegantEmojiPicker.persistedSkinTones
        emojis = emojis.map({
            if !$0.supportsSkinTones { return $0 }
            
            if let persistedSkinToneStr = persistedSkinTones[$0.description], let persistedSkinTone = EmojiSkinTone(rawValue: persistedSkinToneStr) {
                return $0.duplicate(persistedSkinTone)
            } else if let defaultSkinTone = config.defaultSkinTone, persistedSkinTones[$0.description] != "" {
                return $0.duplicate(defaultSkinTone)
            }
            
            return $0
        })
        
        var emojiSections = [EmojiSection]()
        
        let currentIOSVersion = UIDevice.current.systemVersion
        
        for emoji in emojis {
            if emoji.iOSVersion.compare(currentIOSVersion, options: .numeric) == .orderedDescending { continue } // Skip unsupported emojis.
            
            let localizedCategoryTitle = localization.emojiCategoryTitles[emoji.category] ?? emoji.category.rawValue
            
            if let section = emojiSections.firstIndex(where: { $0.title == localizedCategoryTitle }) {
                emojiSections[section].emojis.append(emoji)
            } else if config.categories.contains(emoji.category) {
                emojiSections.append(
                    EmojiSection(title: localizedCategoryTitle, icon: emoji.category.image, emojis: [emoji])
                )
            }
        }
        
        return emojiSections
    }
    
    /// Get emoji search results for a given prompt, using the default search algorithm. First looks for matches in aliases, then in tags, and lastly in description. Sorts search results by relevance.
    /// - Parameters:
    ///   - prompt: Search prompt to use.
    ///   - fromAvailable: Which emojis to search from.
    /// - Returns: Array of [Emoji] that were found.
    static public func getSearchResults (_ prompt: String, fromAvailable: [EmojiSection] ) -> [Emoji] {
        if prompt.isEmpty || prompt == " " { return []}
        
        var cleanSearchTerm = prompt.lowercased()
        if cleanSearchTerm.last == " " { cleanSearchTerm.removeLast() }
        
        var results = [Emoji]()

        for section in fromAvailable {
            results.append(contentsOf: section.emojis.filter {
                $0.aliases.contains(where: { $0.localizedCaseInsensitiveContains(cleanSearchTerm) }) ||
                $0.tags.contains(where: { $0.localizedCaseInsensitiveContains(cleanSearchTerm) }) ||
                $0.description.localizedCaseInsensitiveContains(cleanSearchTerm)
            })
        }
        
        return results.sorted { sortSearchResults($0, $1, prompt: cleanSearchTerm) }
    }
    
    static func sortSearchResults (_ first: Emoji, _ second: Emoji, prompt: String) -> Bool {
        let regExp = "\\b\(prompt)\\b"
        
        // The emoji which contains the exact search prompt in its aliases (first priority), tags (second priority), or description (lowest priority) wins. If both contain it, return the shorted described emoji, since that is usually more accurate.
        
        if first.aliases.contains(where: { $0.range(of: regExp, options: .regularExpression) != nil }) {
            if second.aliases.contains(where: { $0.range(of: regExp, options: .regularExpression) != nil }) {
                return first.description.count < second.description.count
            }
            return true
        } else if second.aliases.contains(where: { $0.range(of: regExp, options: .regularExpression) != nil }) {
            return false
        }
        
        if first.tags.contains(where: { $0.range(of: regExp, options: .regularExpression) != nil }) {
            if second.tags.contains(where: { $0.range(of: regExp, options: .regularExpression) != nil }) {
                return first.description.count < second.description.count
            }
            return true
        } else if second.tags.contains(where: { $0.range(of: regExp, options: .regularExpression) != nil }) {
            return false
        }
        
        if let _ = first.description.range(of: regExp, options: .regularExpression) {
            if let _ = second.description.range(of: regExp, options: .regularExpression) {
                return first.description.count < second.description.count
            }
            return true
        } else if let _ = second.description.range(of: regExp, options: .regularExpression) {
            return false
        }
        
        return false
    }
    
}
