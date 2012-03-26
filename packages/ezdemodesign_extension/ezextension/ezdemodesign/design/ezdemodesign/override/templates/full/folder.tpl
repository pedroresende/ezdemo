{* Folder - Full view *}
{set scope=global persistent_variable=hash('left_menu', false(),
                                           'extra_menu', false())}

{def $rss_export = fetch( 'rss', 'export_by_node', hash( 'node_id', $node.node_id ) )}

<section class="content-view-full">
    <div class="class-folder row">
        <div class="span8">
            {if $rss_export}
            <div class="attribute-rss-icon">
                <a href="{concat( '/rss/feed/', $rss_export.access_url )|ezurl( 'no' )}" title="{$rss_export.title|wash()}"><img src="{'rss-icon.gif'|ezimage( 'no' )}" alt="{$rss_export.title|wash()}" /></a>
            </div>
            {/if}

            <div class="attribute-header">
                <h1>{attribute_view_gui attribute=$node.data_map.name}</h1>
            </div>

            {if eq( ezini( 'folder', 'SummaryInFullView', 'content.ini' ), 'enabled' )}
                {if $node.object.data_map.short_description.has_content}
                    <div class="attribute-short">
                        {attribute_view_gui attribute=$node.data_map.short_description}
                    </div>
                {/if}
            {/if}

            {if $node.object.data_map.description.has_content}
                <div class="attribute-long">
                    {attribute_view_gui attribute=$node.data_map.description}
                </div>
            {/if}

                <div class="attribute-tags">
                    {attribute_view_gui attribute=$node.data_map.tags}
                </div>

            {if $node.object.data_map.show_children.data_int}
                {def $page_limit = 10
                     $classes = ezini( 'MenuContentSettings', 'ExtraIdentifierList', 'menu.ini' )
                     $children = array()
                     $children_count = ''}

                {if le( $node.depth, '3')}
                    {set $classes = $classes|merge( ezini( 'ChildrenNodeList', 'ExcludedClasses', 'content.ini' ) )}
                {/if}

                {set $children_count=fetch_alias( 'children_count', hash( 'parent_node_id', $node.node_id,
                                                                          'class_filter_type', 'exclude',
                                                                          'class_filter_array', $classes ) )}

                <section class="content-view-children">
                    {if $children_count}
                        {foreach fetch_alias( 'children', hash( 'parent_node_id', $node.node_id,
                                                                'offset', $view_parameters.offset,
                                                                'sort_by', $node.sort_array,
                                                                'class_filter_type', 'exclude',
                                                                'class_filter_array', $classes,
                                                                'limit', $page_limit ) ) as $child }
                            {node_view_gui view='line' content_node=$child}
                        {/foreach}
                    {/if}
                </section>

                {include name=navigator
                         uri='design:navigator/google.tpl'
                         page_uri=$node.url_alias
                         item_count=$children_count
                         view_parameters=$view_parameters
                         item_limit=$page_limit}

            {/if}
        </div>
        <div class="span4">
            <aside>
                <section class="content-view-aside">
                    <div class="attribute-call-for-action">
                        {attribute_view_gui attribute=$node.data_map.call_for_action}
                    </div>
                </section>
            </aside>
        </div>
    </div>
</section>
