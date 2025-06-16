//
//  TemplateSelectionView.swift
//  HealthJournal
//
//  Created by Ryan Cook on 6/1/25.
//

import SwiftUI

struct TemplateSelectionView: View {
    @Binding var selectedTemplate: JournalTemplate?
    let templates: [JournalTemplate] = [
        JournalTemplate(name: "How to Use Templates", prompts: [
            "Templates help you quickly structure your journal entries.",
            "Select a template to auto-fill prompts for reflection, mood, sleep, and more.",
            "You can manage or create your own templates soon!"
        ]),
        JournalTemplate(name: "Mood Tracker", prompts: ["How do you feel today?", "What affected your mood?"]),
        JournalTemplate(name: "Sleep Quality", prompts: ["How did you sleep?", "Any dreams?"]),
        JournalTemplate(name: "Daily Reflection", prompts: ["What went well today?", "What could be improved?"])
    ]

    var body: some View {
        List(templates) { template in
            Button(action: {
                selectedTemplate = template
            }) {
                HStack {
                    Text(template.name)
                    if selectedTemplate?.id == template.id {
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .navigationTitle("Templates")
    }
}
