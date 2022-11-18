import pytermgui as ptg


class Suggestion(object):
    suggestion: str
    id: int

    def __init__(self, id: int, suggestion: str):
        suggestion = suggestion.replace("\t", "    ")
        self.suggestion = suggestion
        self.id = id

    def get_source_code(self):
        return "HELLO FROM : " + str(self.id)

    def get_as_collapsible(self, manager: ptg.WindowManager, wizard):
        return ptg.Button(label=self.suggestion.split("\n")[0],
                          onclick=lambda *_: self.__show_details_and_code(manager, wizard))


    def __show_details_and_code(self, manager: ptg.WindowManager, wizard):
        self.__show_details_section(manager, wizard)
        self.__show_code_section(manager, wizard)


    def __show_details_section(self, manager: ptg.WindowManager, wizard):
        # close window
        for slot in manager.layout.slots:
            if slot.name == "body_1":
                slot.content.close()

        # create new details window
        details_window = (
            ptg.Window(
                ptg.Label(self.suggestion, parent_align=ptg.enums.HorizontalAlignment.LEFT)
            )
            .set_title("Details")
        )
        details_window.overflow = ptg.Overflow.SCROLL
        manager.add(details_window, assign="body_1")


    def __show_code_section(self, manager: ptg.WindowManager, wizard):
        # close window
        for slot in manager.layout.slots:
            if slot.name == "body_2":
                slot.content.close()

        content = ptg.Container()
        content.lazy_add("Load file: " + self.suggestion.split("\n")[0].split(":")[1])
        content.lazy_add("Jump to line: " + self.suggestion.split("\n")[1].split(":")[2])
        content.lazy_add("Highlight until line: " + self.suggestion.split("\n")[2].split(":")[2])

        # create new code window
        code_window = (
            ptg.Window(
                content
            )
            .set_title("Details")
        )
        code_window.overflow = ptg.Overflow.SCROLL
        manager.add(code_window, assign="body_2")
