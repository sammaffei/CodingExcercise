
# Coding Exercise
iOS Engineer Candidate Code Exercise


### Requirement doc

iOS-code-exercise.pdf

### Building the Targets

- This project uses CocoaPods.
- This project requires Xcode 10.
- After cloning the project from GitHub, run "`pod install`" in the project directory.
- Launch the project in Xcode 10 by opening the "CodingExercise.xcworkspace".
- There are two targets that you can build "SimpsonsViewer" and "WireViewer"
- If you need to install CocoaPods, you can look here https://guides.cocoapods.org/using/getting-started.html


### Development Motivations
- After reading the project overview, it became readily apparent that the only differences between the apps where the REST URLs, titles, project settings. That’s when I made the decision to make 2 Targets (“SimpsonsViewer” and “WireViewer”). That way you can easily swap the settings like the Bundle Identifier and share the same code files between the projects. If you look in the file “Constants.swift”, I actually swap out the definitions of a few key Constants based on Swift Active Compilation Conditions that are defined in each target (and left it open ended if you want to do more). “Constants.swift” is the only file in the project that does this to a keep conditionalization to minimum and in a contained place. All of the source / resource files in both apps are shared. The other bonus of separate targets is that you can have an altered storyboard or redefinition of classes per app by just including / excluding files based on the target.
- I identified that most of the apps’ behavior closely resembles the base Master / Detail App template provided by Xcode. Always being a believer in “if it’s already there, use it”, this seemed like the logical choice. Also, Apple provides that template because it's how they believe such interfaces should be implemented. Furthermore, it makes the display code dead simple. KISS.
- The JSON processing code was simple enough that a DataTask and the default Apple JSON Serialization was enough to get the job done. I felt a open source library for that would have been overkill. Now, I chose SDWebImage for loading the images because I’ve used it for years in projects that needed image loading and caching. SDWebImage is quick, reliable, and simple to use. CocoaPods is used to incorporate the open source libs.
- The collections view cells use a protocol for setting up the cell. This make creating and configuring cells quite easy. The cell creation / dequeueing routine only has to set a simple cell identifier based on the collection mode.
- The mode toggle (text / icon) never directly accesses the collection view implementation. The segmented control just sets the curMode on the collection view. That in turn triggers a didSet messaging chain that reloads the table into the new state.
