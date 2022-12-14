// CategoriesView.swift

import SwiftUI
import Combine

import os.log
let logger = Logger(subsystem: "VK", category: "VK")

let horizontalPadding: CGFloat = 16

struct CategoriesView: View {
    
    @State var categories = sampleData
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            availableCategories
                .transition(.move(edge: .leading).combined(with: .opacity))
            
            chosenCategories
                .transition(.slide)
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            header
        }
        .safeAreaInset(edge: .bottom) {
            footer
        }
        .padding(.horizontal, horizontalPadding)
    }
    
    @ViewBuilder var availableCategories: some View {
        if categories.contains(where: { !$0.chosen }) {
            Section {
                CategoriesLayout {
                    ForEach(Array(categories.enumerated()), id: \.offset) { index, category in
                        if !category.chosen {
                            categoryItem(from: category)
                                .transition(.customSlide)
                                .onTapGesture {
                                    withAnimation {
                                        categories[index].chosen = true
                                    }
                                }
                        }
                    }
                }
            } header: {
                Text("Доступные категории")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
            }
        }
    }
    
    @ViewBuilder var chosenCategories: some View {
        if categories.contains(where: { $0.chosen }) {
            Section {
                CategoriesLayout {
                    ForEach(Array(categories.enumerated()), id: \.offset) { index, category in
                        if category.chosen {
                            categoryItem(from: category)
                                .transition(.customSlide)
                                .onTapGesture {
                                    withAnimation {
                                        categories[index].chosen = false
                                    }
                                }
                        }
                    }
                }
            } header: {
                Text("Выбранные категории")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
            }
        }
    }
    
    @ViewBuilder func categoryItem(from category: Category) -> some View {
        HStack(spacing: category.chosen ? 16 : 8) {
            Text(category.name)
                .font(.system(size: 16, weight: .semibold))
            
            if !category.chosen {
                Divider()
            }
            
            Image(systemName: category.chosen ? "checkmark" : "plus")
                .font(.system(size: category.chosen ? 18 : 20))
                .bold(category.chosen)
            
        }
        .padding(11)
        .background(category.chosen ? Color.categoryBackgroundChosen : Color.categoryBackgroundNotChosen)
        .cornerRadius(12)
        .frame(height: 40)
    }
    
    @ViewBuilder var header: some View {
        HStack(spacing: 12) {
            Text("Отметьте то, что вам интересно, чтобы настроить Дзен")
                .font(.system(size: 16))
                .foregroundColor(.headerText)
            
            Button {
                // skip choosing categories
            } label: {
                Text("Позже")
                    .font(.system(size: 16))
                    .padding(.horizontal, 13)
                    .padding(.vertical, 10)
                    .foregroundColor(.white)
                    .background(Color.headerButtonBackground)
                    .cornerRadius(40)
            }
        }
        .padding(.bottom)
        .frame(maxWidth: .infinity)
        .background(.black)
    }
    
    @ViewBuilder var footer: some View {
        if categories.contains(where: { $0.chosen }) {
            Button {
                let userChosenCategories = categories.compactMap {
                    if $0.chosen {
                        return $0
                    }
                    return nil
                }
                // continue with `userChosenCategories`
            } label: {
                Text("Продолжить")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(.white)
                    .cornerRadius(30)
            }
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
            .preferredColorScheme(.dark)
    }
}
