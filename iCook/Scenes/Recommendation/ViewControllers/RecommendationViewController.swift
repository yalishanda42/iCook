//
//  RecommendationViewController.swift
//  iCook
//
//  Created by Alexander Ignatov on 25.05.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

/*
 * This is a test implementation of the viewcontroller for the recommendation scene,
 * developed so as to show an example design of the page.
 */
class RecommendationViewController: SceneViewController<RecommendationViewModel> {
    
    // MARK: - Outlets

    @IBOutlet private weak var doneButton: UIBarButtonItem!
    @IBOutlet var optionLabels: [UILabel]!
    @IBOutlet var optionButtons: [UIButton]!
    
    // MARK: - Properties
    
    private let segueId = "pickerPresentation"
    
    // MARK: - Setup
    
    override func setupViews() {
        super.setupViews()
        
        optionButtons.enumerated().forEach { (index, button) in
            let tag = index + 1  // avoid views with tag == 0
            button.tag = tag
            button.setTitle(Option(rawValue: tag)!.options.first!, for: .normal)
        }
    }
    
    override func setupBindings() {
        super.setupBindings()
        
        viewModel.transform(RecommendationViewModel.Input(generateButtonTap: doneButton.rx.tap.asObservable()))
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == segueId,
            let pickerController = segue.destination as? PickerViewController,
            let button = sender as? UIButton
        else {
            return
        }
        
        guard let option = Option(rawValue: button.tag),
            let buttonTitle = button.title(for: .normal),
            let selectedOptionIndex = option.options.firstIndex(of: buttonTitle)
        else {
            fatalError("nimoish kodish")
        }
        
        pickerController.data = option.options
        pickerController.selectedValueIndex = selectedOptionIndex
        pickerController.callback = { newIndex in
            button.setTitle(option.options[newIndex], for: .normal)
        }
    }

}

extension RecommendationViewController {
    enum Option: Int {
        case type = 1
        case cookingTime
        case vegetarianity
        case allergies
        case halal
        case test
        
        var options: [String] {
            switch self {
            case .type: return ["Breakfast", "Lunch", "Dinner", "Dessert", "Salad", "Any"]
            case .cookingTime: return ["Under 30min", "30~60min", "90~120min", "120min+", "Doesn't matter"]
            case .vegetarianity: return ["None", "Vegan", "Vegetarian"]
            case .allergies: return ["None", "Gluten-free"]
            case .halal: return ["No", "Yes", "Doesn't matter"]
            case .test: return ["Blabla", "Blablablablabla", "Blabla blabla", "Bla!"]
            }
        }
    }
}
