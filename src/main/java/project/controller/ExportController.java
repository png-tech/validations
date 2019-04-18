package project.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import project.aspect.LoggingThat;
import project.model.eventlog.EventLogType;
import project.model.mapper.EmptyResponseMapper;
import project.model.message.MessageExportRow;
import project.model.validation.ValidationExportRow;
import project.service.ExportService;
import project.view.ValidationExportView;

@Controller
@RequestMapping("export")
@Transactional
public class ExportController {

    private final ExportService service;

    private final ValidationExportView exportExcelView;

    @Autowired
    public ExportController(ExportService service, ValidationExportView exportExcelView) {
        this.service = service;
        this.exportExcelView = exportExcelView;
    }

    @RequestMapping(method = RequestMethod.GET, path = "excel")
    @LoggingThat(type = EventLogType.EXPORT, operation = "Выгрузка данных проверок в EXCEL", mapper = EmptyResponseMapper.class)
    public ModelAndView exportExcel() {
        if (true) {
            throw new RuntimeException("Smile :) This is bug!");
        }
        List<MessageExportRow> messages = service.getMessages();
        List<ValidationExportRow> validations = service.getValidations();
        return new ModelAndView(exportExcelView, new HashMap<String, Object>(){{
            put("messages", messages);
            put("validations", validations);
        }});
    }
}
