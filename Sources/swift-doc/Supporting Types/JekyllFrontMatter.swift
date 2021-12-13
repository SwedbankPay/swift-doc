func jekyllFrontMatter(_ page: Page) -> String {
    return """
---
title: \(page.title)
---

"""
}
