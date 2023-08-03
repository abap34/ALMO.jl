abstract type AbstractBlock end


struct H1 <: AbstractBlock
    content::String
end


struct CodeBlock <: AbstractBlock
    title::Union{Nothing,String}
    in_file::Union{Nothing,String}
    out_file::Union{Nothing,String}
end


struct PlainText <: AbstractBlock
    content :: String
end


struct MathBlock <: AbstractBlock
    content :: String
end


function render(block::H1)
    return "<h1> $(block.content) </h1>"
end


function render(block::CodeBlock)
    title = "<h2 class=\"problem_title\"> <div class=\'badge\' id=\'$(objectid(block))_status\'>WJ</div>  $(block.title) </h2> \n"
    
    area = "<div class=\"editor\" id=\"$(objectid(block))\" rows=\"3\" cols=\"80\"></div> \n"
    area_ace = """
    <script> 
    
    editor = ace.edit(\"$(objectid(block))\"); 
    editor.setTheme("ace/theme/monokai");
    editor.session.setMode("ace/mode/python");
    editor.setShowPrintMargin(false);
    editor.setOptions({
      enableBasicAutocompletion: true,
      enableSnippets: true,
      enableLiveAutocompletion: true
    });
    editor.setValue("");
    
    </script>
    
    
    """

    
    output_area = "出力: <textarea class=\"output\" id=\"$(objectid(block))_out\" rows=\"3\" cols=\"80\"></textarea> \n"


    expect_out_area = "答え: <textarea class=\"expect_out\" id=\"$(objectid(block))_expect_out\" rows=\"3\" cols=\"80\"></textarea> \n"

    run_button = "<button class=\"runbutton\" onclick=\"runCode(\'$(objectid(block))\', \'$(block.in_file)\', \'$(block.out_file)\')\"> Run </button> \n"
    return  join(
        [title, area, area_ace, output_area, expect_out_area, run_button]
    )
end


function render(block::PlainText)
    return block.content
end


function render(block::MathBlock)
    return """\\[
        $(block.content)
        \\]"""
end
    


function parse(S)
    result = AbstractBlock[]
    while !(isempty(S))
        s = popfirst!(S)
        if startswith(s, "#")
            push!(result, H1(s[2:end]))
        elseif startswith(s, ":::code")
            title = nothing
            in_file = nothing
            out_file = nothing
            block = true
            while block
                s = popfirst!(S)
                if startswith(s, "in=")
                    in_file = s[4:end]
                elseif startswith(s, "title=")
                    title = s[7:end]
                elseif startswith(s, "out=")
                    out_file = s[5:end]
                elseif startswith(s, ":::")
                    push!(result, CodeBlock(title, in_file, out_file))
                    block = false
                end
            end
        elseif startswith(s, "\$\$")
            block = true
            math = ""
            while block
                s = popfirst!(S)
                if startswith(s, "\$\$")
                    push!(result, MathBlock(math))
                    block = false
                else
                    math *= s * "<br>"
                end
            end
        else
            push!(result, PlainText(s * "<br>"))
        end
    end
    return result
end



function load_template(;filename="template.html")
    template = readlines(filename)
    split_idx = findfirst((x -> occursin("<!-- ___split___ -->", x)), template)
    return template[begin:split_idx-1], template[split_idx+1:end]
end



function render(result::AbstractArray{<:AbstractBlock})
    TEMPLATE_HEAD, TEMPLATE_TAIL = load_template()
    println.(TEMPLATE_HEAD)
    for r in result
        println(render(r))
    end
    println.(TEMPLATE_TAIL)
end




function main()
    S = readlines("main.md")
    result = parse(S)
    render(result)
end


main()