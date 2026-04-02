from GUI.Visualizers.Base import Base

class Visualizable():
    def __init__(self, visualizer: Base | None = None) -> None:
        self._visualizer = visualizer

    def run_visualizer(self):
        if self._visualizer != None:
            self._visualizer.run()