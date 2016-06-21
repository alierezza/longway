module ApplicationHelper
	def board_details(header, report)
		template = %q[<td class='visual-board' style='%s'>%s</td>]

		case header.upcase
		when "LINE"
			return (template % ["", "#{report.line.nama}"]).html_safe
		when "OPR"
			return (template % ["", "#{report.detailreports.last.opr}"]).html_safe
		when "TRGT"
			return (template % ["", "#{report.detailreports.last.target}"]).html_safe
		when "TRGT SUM"
			return (template % ["", "#{report.detailreports.sum('target')}"]).html_safe
		when "ACT"
			if report.detailreports.last.act < report.detailreports.last.target
				return (template % ["", "#{report.detailreports.last.act}"]).html_safe
			else
				return (template % ["", "#{report.detailreports.last.act}"]).html_safe
			end
		when "ACT SUM"
			return (template % ["", "#{report.detailreports.sum('act')}"]).html_safe
		when "%"
			return (template % ["", "#{Report.percent(report, report.detailreports.last.jam)}"]).html_safe
		when "PPH"
			return (template % ["", "#{Report.pph(report, report.detailreports.last.jam)}"]).html_safe
		when "DEFECT"
			return ((template % ["", "#{Report.total_defect_int(report, report.detailreports.last.jam)}"]) +
				   (template % ["", "#{Report.total_defect_ext(report, report.detailreports.last.jam)}"])).html_safe
		when "RFT"
			return (template % ["", "#{Report.rft(report, report.detailreports.last.jam)}"]).html_safe
		when "REMARK"
			return (template % ["line-height:100%; font-size: 24px", "#{report.detailreports.last.remark}"]).html_safe
		when "ARTICLE"
			return (template % ["", "#{report.detailreports.last.detailreportarticles.last.article}"]).html_safe
		when "EFFICIENT"
			return (template % ["", "#{Report.efficiency(report, report.detailreports.last.jam)}"]).html_safe
		end
	end
end
